Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055891;
	b=N2BYrfwlCkgYOq1WlifYEhzLGSKitioLzAklcid7TOACGQQu2YO80OqYBRNhksDoFm3D
	 Hi3Cyc/jS/msYwkq2+xsMuJivzV/KqEOFtByCMKFVk5EnbZz2faoowbjU6s+VK7tHc5Zr
	 FWyv0dyeVXypIMu5xYJY1O8jtHiX8MW3BCH0hqynu5lrQCLKO/5iKMu7N2vK++kfK+Tu6
	 dgCMsXIT35uOSl4bGuSJqLqaaojk6IzQqH245PHf123dccgv8W+sMuTHy/jOOeWCXwaKK
	 xULYM8iNFtYTvLBBEG96JYJq0209sVpwRgBg1rHvujn7TMZScz+58Dn1119TnDGIuaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YEZAHkacmgfO/d88qmrF9qqWDNYNsw+O75PLi+dApQk=;
	b=rLE29sSrn/vGxikBF0VKdKJDMmrLeiiqGYWJRwuGCs5se4ClmTlnlbiVwmm3TflBPRLv
	 XNoe9GkclS8IZI07/MYT3nMRIQqTMYMsSOm5OzeuO7JwVKzmbwDyaL0HvyOgoBMbDEMVO
	 HbZtToqcLbdo7rqqFSMqjsBecZdKfAANR6/6xsNDzEtfcTDcXDeyE7iky32f3NN3NAa9S
	 QOeAwE9fYh2ATG4Ku3cYbqmqn+xLsMVwerWaIliWtP2FsD5RNa9xgU7Mcsd9u/QWw6gw2
	 h7fioHh4qG4v/AIlQKkHuPnK75f49XmPlHvYD8zgKsVavmk2cg2lRLMgyitvcX/Cnpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcvPOlZ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6A0606A32C;
	Thu, 19 Nov 2026 02:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcvPOlZ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694021F000C4;
	Thu, 19 Nov 2026 02:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055891;
	bh=YEZAHkacmgfO/d88qmrF9qqWDNYNsw+O75PLi+dApQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcvPOlZ3tB9IVApRiJF9amz/PwXoOZwWKOiHWFIOAmBzhdDOG3tjasRNH3yyr18AX
	 jnlK5BywRCFJvI4xygdboryxvi9JBO3cj7YxKz8A4aBq3n65IoB4E6ZcALj3Za+VQb
	 J2nli6baB91IBzVdbkCgutGbY+AG021YjuZap1z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1793/2214] pinctrl: sprd: free maps on DT map failure
Date: Wed, 18 Nov 2026 15:57:49 +0100
Message-ID: <20261118150123.225729792@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit e873c665e503ebfb6dafaf9346c3956695686226 ]

sprd_dt_node_to_map() reserves map storage before adding mux and
configuration entries.  If a later operation fails, the error path only
frees the temporary configurations and leaves the map allocation reachable
through the output pointer.

Free the partially built map on failure.  The caller ignores the output
parameters when the mapping callback returns an error, so they do not need
to be reset after freeing the map.

Fixes: 41d32cfce1ae ("pinctrl: sprd: Add Spreadtrum pin control driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sprd/pinctrl-sprd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/sprd/pinctrl-sprd.c b/drivers/pinctrl/sprd/pinctrl-sprd.c
index dca7a505d4137..89ecab083b202 100644
--- a/drivers/pinctrl/sprd/pinctrl-sprd.c
+++ b/drivers/pinctrl/sprd/pinctrl-sprd.c
@@ -327,6 +327,9 @@ static int sprd_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 out:
 	kfree(configs);
+	if (ret < 0)
+		pinctrl_utils_free_map(pctldev, *map, *num_maps);
+
 	return ret;
 }
 
-- 
2.53.0



