Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024561;
	b=Z15I5xQv8WyMXijaNmT2OB+DEICveszuiDnMYZOTdMr4nU/zX8N44k3ZqL4yiCxjDG22
	 cIUONypeKxiCKFPoGE1jZPhF9nsZtF8XOXHP1AeL9oiIzNZz1S4Lt2P2uHvut8FvR4k17
	 flBssMtmtWCCLx7T2Oi8WB8Xz6anFYoj61WMVSCMdiusTQSABb1jxNRoeB5Lyr1dX9q5v
	 rOlWHopuZxn0Yx8kQSk5kDGdsn32ODka76HtIQkGon4/5i5akL4nRnaHrVSHUBF2l+Ns0
	 OaP7Sp5HuL4hfdSkOu2tsuh6VRnAvjkXKoO83U2L5+Jj9ekrhvyWm1IU1vqGKsPdvIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aKcorgApls6h5gnqsvnn3z8YR059mSBGd8mavTXA5Dw=;
	b=QR1Fx+t48nAkVuJUN3D1p4B78ru0gbRJYtjZZzpDJRv2ik5nyE1DsHFa0I9yHvEfbe0J
	 Uy70hR+B8zaE4REQE9mmaxTg/IvwPJE+oW4/BmhCHy7G51NovOuvv6R4ka16vZNGQI2pF
	 NQDnaRD6ZIf3D2Yf5Y8v5LsHvaKSvFxA+uIrofE7YPHDwNd2tQTYbbWqoAHzqqTksMdOd
	 x/tZEVXM2e7+Zfcr2pfUF1hrJXMtdvVCNQMcJ1P9d/k2HfvrlGjnasYvhlW7xqW7mb6nk
	 62rgkg1xYIbiuMVCPmeYL7eyzEBCgAj44YfM35TDpwD9qvNxLugy4dmigbcnLvJoHmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EBVW/2CS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C98606A31C;
	Wed, 18 Nov 2026 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EBVW/2CS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100651F000C4;
	Wed, 18 Nov 2026 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024561;
	bh=aKcorgApls6h5gnqsvnn3z8YR059mSBGd8mavTXA5Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBVW/2CSxiF8ZT05Kz+s95A4a+oyf/8RC6oVBxUy4F4iQ0k96jL+Brdu6sxcbmM4k
	 5lbTFtzX60a0Nky/dBVe94X3+pAcQnPO1g5BmkyaTnAkAe0z01wyrJEIjNTQdxU76m
	 w5pzxlhRmgaWknFmiYvEDnxrXyGyRDE8rk58Rgxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0768/2151] bitmap: bitmap_parselist(): reject trailing characters after group size
Date: Wed, 18 Nov 2026 15:41:43 +0100
Message-ID: <20261118150150.060476817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Mohan Jain <jain.sm@gmail.com>

[ Upstream commit c55d102257fa31271c6f11fea595b78c48fd7aa2 ]

bitmap_parse_region() checks that every region ends at a separator
(',', whitespace, '\n' or '\0'), except in the "range:used/group" form:
after parsing the group size it returns the pointer to the following
character without looking at it.  The caller then starts a new region
at that character.

Before 'N' and 'all' were accepted as region starts this happened to be
harmless, because any other character would fail to parse as a new
region.  Now text directly following the group size is silently parsed
as another region:

  "0-7:1/2N"    -> bits 0,2,4,6,7 (nbits = 8), returns 0
  "0-7:1/2all"  -> all bits set, returns 0

while "0-7N", "5N" or "0-7:1/2x" are correctly rejected with -EINVAL.
bitmap_parselist() is documented to return -EINVAL for an invalid
character.  It parses cpu lists from sysfs, cgroup cpuset files and
boot parameters such as isolcpus= and nohz_full=, so a typo there is
accepted and yields a different mask than intended.

Check for the end of the region after the group size as well, like the
other forms do.

Fixes: 2c4885d24e64 ("lib: bitmap: support "N" as an alias for size of bitmap")
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bitmap-str.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/bitmap-str.c b/lib/bitmap-str.c
index 692a150a4d65c..65cd6f60d4360 100644
--- a/lib/bitmap-str.c
+++ b/lib/bitmap-str.c
@@ -332,7 +332,14 @@ static const char *bitmap_parse_region(const char *str, struct region *r)
 	if (*str != '/')
 		return ERR_PTR(-EINVAL);
 
-	return bitmap_getnum(str + 1, &r->group_len, lastbit);
+	str = bitmap_getnum(str + 1, &r->group_len, lastbit);
+	if (IS_ERR(str))
+		return str;
+
+	if (!end_of_region(*str))
+		return ERR_PTR(-EINVAL);
+
+	return end_of_str(*str) ? NULL : str;
 
 no_end:
 	r->end = r->start;
-- 
2.53.0



