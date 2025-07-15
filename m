Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82677263F52;
	Tue, 15 Jul 2025 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586904; cv=none; b=sFrR8AYGBlNSI1pkUIZ3ESZgMi0xAYm9DCPOP9wYs9tUitj1DNVxd8O5f7/rYM04YjqmhFRQna4mNvEgfReSTQgEkdNJlWH3ziccjLrOp9WCS6YTuXu38Kc1tAG0yPZuahZfYCdE6V6AucZjWVgj8OMqsefJSHGC+cHcWeKTORc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586904; c=relaxed/simple;
	bh=l3D+XSbZtboFBJXLX3ywnpcAD5Zqh1TyAWu42y7KbzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLp4FuWwm2yIto+wGS2hFoRHRoOk7p4vr5oETFtJP4bj6lVy7Yv7Erp490iB8djK7VzxXuEzquQkAYdFXI/gZDHHqRJkMUplFXNGRtC2YllVKh+0S5Y3WgOYi8m5SU0fd1i1c/pZeB46JQ2Fs2tLFkEE+1a2Za9IDAIuYi0ovWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbICwjdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbICwjdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185BBC4CEE3;
	Tue, 15 Jul 2025 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586904;
	bh=l3D+XSbZtboFBJXLX3ywnpcAD5Zqh1TyAWu42y7KbzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbICwjdMuVldfmWAkez+IxVlzkPzkhHTs0pPp2vdflqhc7PqT5pahaWYJ0O5WTLV0
	 zFbt5wodNJLMegOdys199sSjpHB5NrCyvEHfwFGn1bpvqa9Wo2vIlUCRL8LYsHKRug
	 yyCyIJNa2ArWdX7pD6U7bsw9HRFNwfUXsfzgwcl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 062/192] ALSA: ad1816a: Fix potential NULL pointer deref in snd_card_ad1816a_pnp()
Date: Tue, 15 Jul 2025 15:12:37 +0200
Message-ID: <20250715130817.429993242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 043faef334a1f3d96ae88e1b7618bfa2b4946388 upstream.

Use pr_warn() instead of dev_warn() when 'pdev' is NULL to avoid a
potential NULL pointer dereference.

Cc: stable@vger.kernel.org
Fixes: 20869176d7a7 ("ALSA: ad1816a: Use standard print API")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20250703200616.304309-2-thorsten.blum@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/ad1816a/ad1816a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -98,7 +98,7 @@ static int snd_card_ad1816a_pnp(int dev,
 	pdev = pnp_request_card_device(card, id->devs[1].id, NULL);
 	if (pdev == NULL) {
 		mpu_port[dev] = -1;
-		dev_warn(&pdev->dev, "MPU401 device busy, skipping.\n");
+		pr_warn("MPU401 device busy, skipping.\n");
 		return 0;
 	}
 


