Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030521;
	b=BA18VVUt0RCnBMiTpehEAhrGD2bUESJNYmxWv2by/FTpdVJC60LZMlWSUDWlUob4jnpY
	 2L2Ycgu4RXVmkZdCvOzWKAjSAzoSPP1yBvsMQYIZvMwQn7g/k2r9gC0/ptxXxtuaRYzOQ
	 1aLyl0jEc8jajbLZ3Kc+EGplqJKXXJ7myTJT0sLhMSy04peDWmlDhLluklVVR8xH5h3y7
	 H82OFiXrasNTqugLDRdRleac1V0ZiZ58NQ4VEG+7aX61GUPDw7twuH8tNThcQ8Px+M9hJ
	 l8m28Cum+rGfxZGZjIlx0RT2KU+87HNWPLnQ4MLTvlzcVuHVXjxssxFfSWTDm/sor4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HDGk7adp5rdS9m8lipu725+qqnuztEqoK5ru8/Aj9fE=;
	b=VR5M4nWSqZ0PrF3aCb+zIudt1+2WRB7vpVYBhZJfDyH9cqes7iy7l7NmxV6u28CmEazk
	 578owqFJ1e3fzECxX3ORVujHLwki5VZCOqwbGpEQJALbMowqk2w0Ymuv+Jq2U3d/fdbCg
	 zUahMKMrR+OfbV0NzsGElGJYjnHEhTZrhuZB+8ny//NDb9gB8iV9AGaPbXc+fDVqze1Dr
	 Ua5bm2YGygxcy0wz1gHm/xK+zUJNFLD6p42I2zCLkefBuAgN22Ka+zWydEWq4NpZ/NRq+
	 PcxRZh0ptB84EfLmWiKMK8RmNwFinYTI9oCNNOHZ7IHFhidNXfIDwY38djScbHo5zEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I5YTgOzL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410B606B10C;
	Wed, 18 Nov 2026 19:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I5YTgOzL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8401F000C5;
	Wed, 18 Nov 2026 19:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030520;
	bh=HDGk7adp5rdS9m8lipu725+qqnuztEqoK5ru8/Aj9fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5YTgOzLM9O8XmhaY5k9WWLoaZ07+LsqlSgfVcIgO+jKCUc6Tdi+Db4UkETFQTTmy
	 5H9rE2a4Png8WmA0JPavbXaV32wCTVbDNRcvFMzwFmoR50eTDsnvfj0pdM8E66Mkcr
	 Lji+UdC+1RTSn6I07Qp9TCgbQEILNCJeEekicieg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0732/1756] ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()
Date: Wed, 18 Nov 2026 15:47:39 +0100
Message-ID: <20261118150038.802083845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 62b9ae8ae4a7f0b93efa1efa230782b37057b1e7 ]

vexpress_flags_set() obtains a reference to the "arm,vexpress-sysreg"
device node via of_find_compatible_node() and passes it to of_iomap(),
but never calls of_node_put() on it. of_iomap() only reads the node's
reg property to create the mapping and does not take ownership, so the
node reference is leaked. The function runs from the __init SMP prepare
path and caches the mapping in a static, so this is a one-shot leak of a
single refcount during boot, with no functional impact.

The lookup was added to drivers/mfd/vexpress-sysreg.c by the commit
below and later moved here by commit 9b06fc39084e ("ARM: vexpress: Move
vexpress_flags_set() into arch code").

Annotate node with the __free(device_node) cleanup attribute so the
reference is released when it goes out of scope.

Found by static analysis tool CodeQL.

Fixes: 974cc7b93441 ("mfd: vexpress: Define the device as MFD cells")
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260925173252.933705-2-geoffreyhe2@gmail.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-versatile/v2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-versatile/v2m.c b/arch/arm/mach-versatile/v2m.c
index 79afdf2a90b6f..c86b38386cf7c 100644
--- a/arch/arm/mach-versatile/v2m.c
+++ b/arch/arm/mach-versatile/v2m.c
@@ -13,8 +13,8 @@ void vexpress_flags_set(u32 data)
 	static void __iomem *base;
 
 	if (!base) {
-		struct device_node *node = of_find_compatible_node(NULL, NULL,
-				"arm,vexpress-sysreg");
+		struct device_node *node __free(device_node) =
+			of_find_compatible_node(NULL, NULL, "arm,vexpress-sysreg");
 
 		base = of_iomap(node, 0);
 	}
-- 
2.53.0



