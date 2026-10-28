Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212629;
	b=UKhyB+kazrsNz+xsTNo0kx09t53w/21B5OIn+1QmtDkbPL4C5tMjlZLbodNAH0eYMEsA
	 1dJIRsZ8U/vZp6qFM5gyoDJeSbtnBq1qOEQRUS7rTn240rzBlrJYkrYvAjrNgeJRHgbkg
	 ZMgLVcHQI1xBh/ssRZC90Rshsz4lhLbi34Jf9/y4/1vkimFT5IDu+SliCr+d9UdbxIMu7
	 cqbkRiAr6OesL8SMiW2BO+i1mJI7/L2h0Ry92Ud6ccq7mSUV4fDePmVD4Vs9as3YDV0T1
	 u3Br2KsbU6HUaxAfgel9F0PC0UF3lmCgVcZeAmTBlXOqvTXDQtKfDRpmlPLQjzCFchA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n6iNQZFMvYS0XTNnaMBTIsI6ujalZGRpW7k7KFEzdNA=;
	b=4AmxO81/5c/6SUJ0mcxb/LxhsDPaj93Z8PNyih9W1+YXjTpgFZXSyXwbT+p4HX+QBFnp
	 yAVkWlI/gLJuROvyPVAhlNioUh72mQf4UOboQK5q0FuNpgRi46ljUIeUfJXQXVOt0fX9g
	 hS5C92+lL4kfQ8rXc0S27FW9RGpeELYuX/R8LTsap5x/AyvL6gXjKbK2gxnV99/QkCjTi
	 9qnxLX12+RLgGnmYvjwUlp5nNYCI8tXzM3BrOeILSjJbbXHxb2BL69tPtySELdf62PB3r
	 ITHQ6ayfo3hQR9+EcecyJ4nwcV1jIgHUXKx9/qxv2eBa7rYzsMgGz30I4conqDQYbUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvsT2Bne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF57606A31A;
	Wed, 28 Oct 2026 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvsT2Bne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDC41F01825;
	Wed, 28 Oct 2026 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212629;
	bh=n6iNQZFMvYS0XTNnaMBTIsI6ujalZGRpW7k7KFEzdNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvsT2BneuXj7DTJeGiNU1sVmRrSGRdufeKTQWu9JSKrMNdowsh9mvhjSTOYryUQSO
	 4u1ilo1aXvmoirLgSvb6cFWNpQyJV1t2DTucBrST/5RJa2Bd8wCv+oRpvm+Z+jWJa/
	 fMITdIj0JYv6Tkpwr9eXhYfmiq0o8UbyntSbQ5w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0221/1887] ASoC: tegra: Fix ASRC Stream6 input threshold control
Date: Wed, 28 Oct 2026 17:38:37 +0100
Message-ID: <20261028170504.261630209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 75fc8a3ee5aee72f2fea3b6436170fae175f7f19 ]

The Stream6 Input Threshold control points at stream index 4, which is
already used by Stream5. The threshold get and put callbacks derive the
lane ID from the register offset, so the duplicate index makes Stream6
operate on lane 4 and leaves lane 5 inaccessible from userspace.

Use stream index 5 for Stream6.

Fixes: a2df8c2d5b36 ("ASoC: tegra: Add Tegra186 based ASRC driver")
Signed-off-by: Sheetal <sheetal@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260921085704.1248920-2-sheetal@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra186_asrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra186_asrc.c b/sound/soc/tegra/tegra186_asrc.c
index 9f12faaa609dd..df25f696efed4 100644
--- a/sound/soc/tegra/tegra186_asrc.c
+++ b/sound/soc/tegra/tegra186_asrc.c
@@ -831,7 +831,7 @@ static const struct snd_kcontrol_new tegra186_asrc_controls[] = {
 		       tegra186_asrc_put_input_threshold),
 
 	SOC_SINGLE_EXT("Stream6 Input Threshold",
-		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 4), 0, 3, 0,
+		       ASRC_STREAM_REG(TEGRA186_ASRC_RX_THRESHOLD, 5), 0, 3, 0,
 		       tegra186_asrc_get_input_threshold,
 		       tegra186_asrc_put_input_threshold),
 
-- 
2.53.0



