Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056416;
	b=OFqTnkP8UziDdTN2gp3zUMJ0wvphcgunElUs0OSWbzxRV1VqeydWY9jbmTi2E4NiOigO
	 9q6GOw754x1BfAGOVG2O3BJn94YhBeSf6NS434vg623nKjhr7YwSKkV3gVW/rVwxAVO3+
	 uEzpv7u9iyh7N1tq/k0wNBFpqnBp7qUBplJSpExBqFDX577EfJsjbNhbWN8fOqzfhsaT1
	 2mh6aM9BH59MrDDOUBd2F1kxaSNo5ivcEHSp/HeJnvfEXMYHZAgTPaJXjpJpxGo3HyT88
	 M87lpPt3+KO1gbneepc5yfnPQYfk5Pd/oK1vKmL0k9GZ+3DxWQiB4W60Gp0JF2sfcFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2jNIAgvBCJcltZ05tHvbijgo6pyyDEM+c+lQAkdKDe8=;
	b=VXq33n8UNmz8EJTEOLzng7Fza4zd3IIg73WKuibvX/HNXe8uLfLzrhQeAclAdbCIFygX
	 JZdh0Jt6hNvPBADTsPNnSZIKjf3CNZ6vG2WFQTQFaNvOIWYu86k7VRJOw8oJyfpfZAWE8
	 hCEFYSXzNEKMdU5C2Dj79yv3xB4ICMS591gcWkKrF7/75pavN/mwcWqYdSH7t8hjTkWqS
	 IdSATN4pLNgXfK9ni9cHKNR29vMGq8Zb8ziteLznWaBmBKtxHLU3k7J5XpUpuxkNTKvoE
	 2tdazTof+5jIXQ9Cyfy20Y4Ma8uYcHNE1U0JqUSiELhRxP7JlZfdWZib46F1CFdA2vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qX038HA1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD07606A320;
	Thu, 19 Nov 2026 02:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qX038HA1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28E91F000C4;
	Thu, 19 Nov 2026 02:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056416;
	bh=2jNIAgvBCJcltZ05tHvbijgo6pyyDEM+c+lQAkdKDe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qX038HA1y1F5ALsq+3d6IyEscwDcqn6PI8CVeKrJIN5qCfJxZEtvTpYCdc3fNwhxi
	 UX7DsgmZ0mclSBJNu+8LmVDMGx/UjUx1QEaGSbQg/Kkq/HShPnieRi7uBiFBkJ2xsx
	 Thaze9rAN3KTqdxKYIOY44TOgFLX7BFNfa7eNv9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1979/2214] ASoC: ops: Fix return value in snd_soc_limit_volume()
Date: Wed, 18 Nov 2026 16:00:55 +0100
Message-ID: <20261118150130.043595418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 223ec2a93bec6c5ee859094c826fec78516a0bb3 ]

As documented snd_soc_limit_volume() should return 0 on success, however
at some point in time this promise was broken when
snd_soc_clip_to_platform_max() was refactored, refactor it once again
using __free() to automatically free struct snd_ctl_elem_value and
return proper value.

Fixes: 7e10d7242ea8 ("ASoC: ops: dynamically allocate struct snd_ctl_elem_value")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-3-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 7cb3a3f9d3ae4..6baade8c1670a 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -624,7 +624,7 @@ EXPORT_SYMBOL_GPL(snd_soc_get_volsw_range);
 static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 {
 	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-	struct snd_ctl_elem_value *uctl;
+	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int ret;
 
 	if (!mc->platform_max)
@@ -636,7 +636,7 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 
 	ret = kctl->get(kctl, uctl);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (uctl->value.integer.value[0] > mc->platform_max)
 		uctl->value.integer.value[0] = mc->platform_max;
@@ -646,10 +646,10 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 		uctl->value.integer.value[1] = mc->platform_max;
 
 	ret = kctl->put(kctl, uctl);
+	if (ret < 0)
+		return ret;
 
-out:
-	kfree(uctl);
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.53.0



