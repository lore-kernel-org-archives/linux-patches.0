Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057335;
	b=evnkT3RRk+NyzcnwoOWLaMnwG36vpvA2vLgF71/PswkkJlUK714dB52JS0vZoYH3NM1V
	 Zviyy77qd9G9mZqoC1/D7hp0mQ9qKqr1UUAaGfHQo/svPqMYxcQQ1oVn8wu9+LvgyQbsL
	 +aCmEBn0Ub24PR+gHmJNgDDKsK46t7ugIb9gBSC/Jg3kOfK3a4jIwJqtHX5MGf02c33hc
	 Xfn4W/s715KQYKKQcAg/nqyGahNyqMajlOS8DoKbpq9XrAyK6trFKzloXMsXnclPyjJLy
	 7Yt3qeD7DZ/NutHbxFIB8S2QmC1Hxbd0kyPxu/sBnEMBve19J85q1vmP3FwFN1Se6fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WiU0vF517F+8JVZpQhPyGrmVixaGgW6os2xKgCy7uY4=;
	b=JC2usk0oVbC11lVnAvtRF/hvpctdmvBkeqXDQK39qbIUJT40BKMiwQDl9YKIVNhG0QIc
	 bWZPTxX6fYgXVYJc+egcTpURItVBu4DmQijW4R3nAQmH7EvNwMvXwOfh+PrybTd33lXCy
	 rZtpfJer+1xvMfyTzE1bZ6SiP58CernRiVYKm7Kf0iYkpoQx+M7bh6sL6OJfvOOgYQE4G
	 emnqcsSabkIaxOwq8Iftuj3EVcSU349BKPLCiXhylW+tB2d4wZoldtY8R2kBtKs0ByNzf
	 mWmiIGmr1iV2Yl5Lai4NU9WgJy4JR3qw84nkcgURqcm2xJFM6dm+CPoneHpwkAjD/yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SB6/Aw7S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FCC606A339;
	Thu, 19 Nov 2026 03:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SB6/Aw7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277951F000C4;
	Thu, 19 Nov 2026 03:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057334;
	bh=WiU0vF517F+8JVZpQhPyGrmVixaGgW6os2xKgCy7uY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SB6/Aw7S8jpjL8p56zwvo8iyd1WPIEynXvBzBa/aFZTZtnREUrXt0Uv2eiHE256oi
	 eRqYse0G55DNyDkj/8wcaNrokB3ZjcYK6C1F3DydSuXj/CMblmxyZTR70irG6DJmbo
	 A5+d8ilaq5LKh0u5WnXCvlw2R+BpCDmphYd91vV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0092/1848] misc: genwqe: handle a first DMA address of zero
Date: Wed, 18 Nov 2026 15:35:30 +0100
Message-ID: <20261118145914.981197598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit d401772a9e18e837631450844f835229354528a4 ]

genwqe_setup_sgl() uses zero as the initial previous DMA address. DMA
address zero is valid, so a first entry at that address enters the
merge path before last_s has been assigned and dereferences NULL.

Only merge adjacent mappings after an SGL data entry has been created.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260630104923.53827-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 039b923d1d60a..95eba283fce57 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -413,7 +413,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 			size -= size_to_map;
 			map_offs = 0;
 
-			if (prev_daddr == daddr) {
+			if (last_s && prev_daddr == daddr) {
 				u32 prev_len = be32_to_cpu(last_s->len);
 
 				/* pr_info("daddr combining: "
-- 
2.53.0



