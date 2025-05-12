Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5A2550D0;
	Mon, 12 May 2025 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072488; cv=none; b=RlQ1bkOXbSJB1VxnpjUKJpz0mLBaqN77cTvzX23Dk6Emq6aS3/ud9pvkGdvNfn4ZCvsm82UBvSk64oIZCnPTIDUmtMhOCwQWDZCBI24qp1OMWoAHV9SHeYgrrLh1ywIYuMEYlr9cRZJ2e4jzsOqI/ydB1jfHNbpq7ldvTRgoB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072488; c=relaxed/simple;
	bh=dHp+3a45DbakmytNyGoUW5Oe8Fng8DjcrPSo5VTy8Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGjToqEz7l4xVOpKfZPTEeL6rz075nRc/RrZJegccLy83QCx0t0bCFmgGXdVYzjSx57TFoLUD8Up4AlNKhDZDyps1Lus0ShtXmditN//aOBpV60+gF5SeukmjFUYfeoYK/Cg3Mp8vaDp4WTAQZtOKxTYImY6DyP4CERCoFI59B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUTJB0MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUTJB0MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79160C4CEE9;
	Mon, 12 May 2025 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072488;
	bh=dHp+3a45DbakmytNyGoUW5Oe8Fng8DjcrPSo5VTy8Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUTJB0MAYbOOMnzC2L2SPbVA+hcAKTJbERHZB33XD/uW2OBeBA8QPZOzag9zpPEHG
	 /IezCqM2bovKQaTCU8MykIigcIK8kB0WbQpe/F4H/mZr7Dbjcwq05+0UyCKBm7R4ko
	 J0xWHvussWSucdn0DCHE9x+OC9AA4Bk58SQOgH+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Rathgeb <maggu2810@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 26/92] Input: synaptics - enable InterTouch on Dell Precision M3800
Date: Mon, 12 May 2025 19:45:01 +0200
Message-ID: <20250512172024.187715852@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit a609cb4cc07aa9ab8f50466622814356c06f2c17 upstream.

Enable InterTouch mode on Dell Precision M3800 by adding "DLL060d" to
the list of SMBus-enabled variants.

Reported-by: Markus Rathgeb <maggu2810@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB959789DD6D574E16141E5DC4B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -163,6 +163,7 @@ static const char * const topbuttonpad_p
 
 static const char * const smbus_pnp_ids[] = {
 	/* all of the topbuttonpad_pnp_ids are valid, we just add some extras */
+	"DLL060d", /* Dell Precision M3800 */
 	"LEN0048", /* X1 Carbon 3 */
 	"LEN0046", /* X250 */
 	"LEN0049", /* Yoga 11e */


