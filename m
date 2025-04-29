Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB45233735;
	Tue, 29 Apr 2025 17:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949092; cv=none; b=oJcME8A6bpHbkaU3iChLIF9RrC6ix+C3tWSUUzyNmiy8Iy2uUHyLyD5EJLS157k5rgbUPxhERnSlcfYPhsOCcR6VSBom8ALegqatH2qRjHE1olO7ly1LHWR9qmUmL4zZVDADVtyXhC3oVHOAauxhIcMTMiGMshnghb+b8QCD93s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949092; c=relaxed/simple;
	bh=p3RYblvpapUaeEH8ayNTXq6mhA8VLoZIAsyIYwFgyxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKVQlETpneAvSJg48AvfSLJthSoEuyhhjmScxuI3j9V/zhgQxNQxkyMEAwUpAnYWyGMJS+Wpt+5rUEyn4kruIpVDbXHixcLTOm1vSSNCLmeq5NqxcLP144zijRHeiOFh6EPRXrE3gH78+UEDIRUnj3uyJdb0xLAW3Dja3DXlFqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmi4pE+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmi4pE+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243EFC4CEE3;
	Tue, 29 Apr 2025 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949092;
	bh=p3RYblvpapUaeEH8ayNTXq6mhA8VLoZIAsyIYwFgyxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmi4pE+bSxsJ08QhLCLx595FJvfzN1I4/sY6RTna8rktH7qexzaaAxqIGpkVpQPoW
	 lM4Tq/ofdAJI+UYyAsra35+PIhCJ97jSdydkYi8ba8uhMBNxXDstRsz+RqXRoPC3X6
	 vFu6igHRO7TflxJZMMiZ9A7+zGsf1rgCCRwnjF54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.15 211/373] phy: tegra: xusb: Fix return value of tegra_xusb_find_port_node function
Date: Tue, 29 Apr 2025 18:41:28 +0200
Message-ID: <20250429161131.841369371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 045a31b95509c8f25f5f04ec5e0dec5cd09f2c5f upstream.

callers of tegra_xusb_find_port_node() function only do NULL checking for
the return value. return NULL instead of ERR_PTR(-ENOMEM) to keep
consistent.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20211213020507.1458-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -455,7 +455,7 @@ tegra_xusb_find_port_node(struct tegra_x
 	name = kasprintf(GFP_KERNEL, "%s-%u", type, index);
 	if (!name) {
 		of_node_put(ports);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 	np = of_get_child_by_name(ports, name);
 	kfree(name);


