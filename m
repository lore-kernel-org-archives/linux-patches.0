Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049288;
	b=ScvnUINB2sEd3/cgOdpYgS+NnGfqu582qNeV2+abfc6xztDlkmbYwfVue6r3XYNEf4ud
	 1f11NWoj9KTji0Qdo4stHwIxWTu4BkjbFljBo0KZEoOH5WGUCJe3HVStkjPBANd/luTSP
	 Z9lE4tt75gG6phlTzGQCdTxAHPulNKeHXXib72ztqWLuM8lER2pJvYQESwGZUd9/yt6KW
	 iINwjkmb3e2Au0SAho5KLrbQy9prDIipJAWdN54C34McceVE+U5STqvGqMqXAx5mDObe8
	 6HrrAnbMOmLeu0inWQeRiUqxg8R86MHpa3Ko/pA+gFlEBFWL/aRI93rbk3cY0gUxTCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VUShPOhzD4dAZOpEWvVxAJ0kE7tdRxhNcVogg5TG05A=;
	b=bY6pGoJRDK21iE5OXDJN+ldwNHvNwea6FQkLdLUaj3Y56MOAtRigJ4yRS+yD6tTnzb0G
	 erTE5bu34DMod+DWR8uU5uBD47Y2rFQSjxNj/lXGmX2T5xklX3BejxgMbMpS5CarlffiS
	 J/GFEG/cLTahJ/QS6QUIO7f3D5puuGfDMQxbY9RM9w4QorjiH/tkFpZzu4zjSnBTRd3OJ
	 uR57C1nAtQH03KTrwIvQsc0nJvDeWgfvMi9rVLe4O3kfa0g+904g3KFaqcZgVvoaKxypE
	 kW1SWQEzWASmxTzx/khPkhoiwO1ytQzxSEzUkD52K78W6TkD2ggA0akqErI81UKe+sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eysk9430;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E0A606A31C;
	Thu, 19 Nov 2026 00:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eysk9430
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872AA1F000C4;
	Thu, 19 Nov 2026 00:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049288;
	bh=VUShPOhzD4dAZOpEWvVxAJ0kE7tdRxhNcVogg5TG05A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eysk9430oAsNmGlRiS3OHxMcKyTEK+yeoK8vTiifR3/wEoWNlVA2GyVG0fMqCNFZF
	 +GGt4u6B283MyWAov3P80aO0/qUBSboGrE4KDypZFjfNz6vscNJqymT842fyOavgc1
	 dZn6oNQ8O0cy6W4FZ2BqueVFCoeGCxLGvRTUQrKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2298/2857] pinctrl: sprd: free maps on DT map failure
Date: Wed, 18 Nov 2026 15:55:32 +0100
Message-ID: <20261118150324.224065084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



