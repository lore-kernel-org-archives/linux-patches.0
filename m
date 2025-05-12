Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC17E140E34;
	Mon, 12 May 2025 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072910; cv=none; b=SVpu4zdA4wFClxXQfZVpHB6mK/H6qwWELSKu3lqygl1U21PhWjRC/OrNe9sChlEtPCca+dHNEcCxSkp5mSWcuH8/wG6F80Eh4o5oWb2/o8EdN0wZ55/NcB0BHP2udqjGcpkDwY4MoUL1ltCQoTY9FwLEkQai5IlusIhOw7ddNi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072910; c=relaxed/simple;
	bh=j91Q/DAQTX7cGTT1PN3sToxZYVRsoXGJgrxnRfzGH5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGGI7fynglTAdRXoIoo2QPm2IBH8LzsUpb7owVZdfen2Bxntp/MXU/BeoyaTWvw3Yzi7xkvqEtbozZy0ko7dD+/qb9EBz0A34M14uaqVbHDlTA14JKobonmQSzRIORAv4ZgzdYJaxFFpOG/Ahdf+/3JUPlc8Oakj14MSBg2EMnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6O5PfdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6O5PfdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F9BC4CEE7;
	Mon, 12 May 2025 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072910;
	bh=j91Q/DAQTX7cGTT1PN3sToxZYVRsoXGJgrxnRfzGH5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6O5PfdUgXUcCCKqIhc2eKOZ8wRK76Ob2S5m05qDk1hvizidotO2P0jF/KZ6quXaA
	 YnymE1t80GuS15N4UloFddi7wEWIy5yeqEvfARnZYUd02u327uarsiAWGUz7PdakJq
	 vP+RfO9t1s+VPvxlUsiGmehuZEE+YUF9uDic0uEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Eilert <kernel.hias@eilert.tech>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 064/184] Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5
Date: Mon, 12 May 2025 19:44:25 +0200
Message-ID: <20250512172044.443795083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 2abc698ac77314e0de5b33a6d96a39c5159d88e4 upstream.

Enable InterTouch mode on TUXEDO InfinityBook Pro 14 v5 by adding
"SYN1221" to the list of SMBus-enabled variants.

Add support for InterTouch on SYN1221 by adding it to the list of
SMBus-enabled variants.

Reported-by: Matthias Eilert <kernel.hias@eilert.tech>
Tested-by: Matthias Eilert <kernel.hias@eilert.tech>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB9597C033C4BC20EE2A0C4543B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -190,6 +190,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2068", /* T14 Gen 1 */
+	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */


