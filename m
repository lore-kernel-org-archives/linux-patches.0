Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C108825A2BF;
	Mon, 12 May 2025 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071901; cv=none; b=Pj8ZKuECpxOqe0IR+N+Q1TW3g94jRNANiATlTdC1YnSrUSgCNuZymC5WQF9lY7mbfG4HpCr9DR1UKnYdEZ789FxbAE6D/BM1bN1gEdVLyValEHxAoe2rMXB4m9wpBAoovw0UcaIzBfSYhA6rh2nzJyxPDmdeNYfzvIP8m1XTcIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071901; c=relaxed/simple;
	bh=q25YlS8YiV+eaYXI80heDi7dCSU/ZcxfgKhpMguV4Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyMc0Xmw3fhs5V4ynWGu6zuHBdR5qSqrMmZgdHw+6PUmhs++62rJdNo7RGju/Xq1kUWpUdE7mYHPA9bx4uZ4h+OyxVVQfSpBjXQybqiHS5tXdFxu2gYoMpGBxuMhO14ZOsgQFk+nT6JAEwRGum/murwcOZjAn5p7TsNP9JmnqDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LitF2gG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LitF2gG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A94C4CEE7;
	Mon, 12 May 2025 17:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071901;
	bh=q25YlS8YiV+eaYXI80heDi7dCSU/ZcxfgKhpMguV4Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LitF2gG/Vii60hyMEVXTCvPdni5knhPlKNGHfz1DoO5Tr69vdu6YIxKj9Kw+i14AX
	 STQL4mnP7sl8mLjwSDfI30WCGdBWk+XEgiYZK5d95+b13qohQAy/GEzGgPeQzykKdH
	 8tWF7YmFaVZEzm6kJj6nYr99Yv6glbCCUKLaDOCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jt <enopatch@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 063/197] Input: synaptics - enable SMBus for HP Elitebook 850 G1
Date: Mon, 12 May 2025 19:38:33 +0200
Message-ID: <20250512172046.948755995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f04f03d3e99bc8f89b6af5debf07ff67d961bc23 upstream.

The kernel reports that the touchpad for this device can support
SMBus mode.

Reported-by: jt <enopatch@gmail.com>
Link: https://lore.kernel.org/r/iys5dbv3ldddsgobfkxldazxyp54kay4bozzmagga6emy45jop@2ebvuxgaui4u
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
+	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */


