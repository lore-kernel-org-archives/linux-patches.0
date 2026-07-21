Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A2E3F12CE;
	Tue, 21 Jul 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654313; cv=none; b=D8WK83BWLUUbb2OjaFhwEZqeSFpVZ/Wntcf0DBm8SNEj7zIVDi5MLqRPtJyMi9RhX6u6si3Jla2l8+lSq5dynsB/rs9qNSnZySrL5IWt6e9axQTbKd1QHEVUsw2gPk6A8WsUAVNBhG3SUMy7dxNE4C2JzrQv6TdxPK8S60JVsl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654313; c=relaxed/simple;
	bh=6x0Fs54yea8Q5wjhE3G9pgg8ES1iTwKq/Gmj33jQUsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rppnA1TDWwEml7lKnmDkyRMKw8E6ImC/KjePEF2iLmaUVF7Z1kozHIB8dNgyiXICTGHy/i4sb3u/6q4LvlawqDV8reBfxeb/biLSVcVnRgspnINNZrNGNGmOMwbrHaFSjxDDIkpXODamyK9dxrUkgNI5M9EMQDP9mYYz1T5HQAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJBEQLg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJBEQLg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985A21F000E9;
	Tue, 21 Jul 2026 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654312;
	bh=lc3yuhZ59qbeJmEXtVBoftjBS8ZKF7tRAVJwUvmuUns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJBEQLg5RxnbkNKmv1JuNFlIfBLXU1t/ix6Adlu81cmZ2Zj8GbQLIIeV1xz5Dx+6E
	 jGyE3Bh9tneWbH6BPIxpB4md50EToseShubeVMKzQorYVEStXa0OWfGcrFmgDOAEYK
	 toIP/S+yiXjF20HNn1BLnLg+B7amJIHsHoiiwwMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje@dujemihanovic.xyz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.1 1655/2077] backlight: ktd2801: Enable BL_CORE_SUSPENDRESUME
Date: Tue, 21 Jul 2026 17:22:08 +0200
Message-ID: <20260721152631.783182010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duje Mihanović <duje@dujemihanovic.xyz>

commit f37f5a2ac9d3737617c08f0dc7270b42e9cad907 upstream.

Boards using this backlight chip do not power the backlight off on
suspend. Enable BL_CORE_SUSPENDRESUME so the chip gets powered off by
the backlight core on suspend.

Tested on samsung,coreprimevelte.

Cc: stable@vger.kernel.org # v6.19
Signed-off-by: Duje Mihanović <duje@dujemihanovic.xyz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260328-ktd2801-pm-fix-v1-1-007cb103faeb@dujemihanovic.xyz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/ktd2801-backlight.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/ktd2801-backlight.c
+++ b/drivers/video/backlight/ktd2801-backlight.c
@@ -53,6 +53,7 @@ static int ktd2801_update_status(struct
 }
 
 static const struct backlight_ops ktd2801_backlight_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
 	.update_status = ktd2801_update_status,
 };
 


