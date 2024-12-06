Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C814D2BD;
	Fri,  6 Dec 2024 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498258; cv=none; b=gw32bksUoIe+IIWwI+zakCc2RXyMT4HcmpSypuV6RJpwqsCwIH/pmEM6QAcQhJs3pC2Y3/ZFkgIqt2fqSh5KNe+u2G2gXXKL3YqvkotRAAow4m7fx469PwoDcfBW7FjUoibhaW3gfDGPOqnaBEa60mGiL8rbxz3GzIrV9p/p7C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498258; c=relaxed/simple;
	bh=g1ZtN8DaZyonN7u9Q2um47Yf7MC/pcQMcpxlkQiPMbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8ixDIrvJnwm7pOK0y86etGVTv0s6chYDXmojX+2ZBYbUXBTyEvrGFQU/I+j0J9zOQX2ylQfZGgrGYcQO06bvzqupUKcEJUov4ltAtX+im8I9cEy2TXuz9hDbB/2HL0ZbNpqdlfeQ6mRnLjxPZ7mYVMka/D7vJvrW81Zs+r3cgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/iC38qK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/iC38qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D68C4CED1;
	Fri,  6 Dec 2024 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498258;
	bh=g1ZtN8DaZyonN7u9Q2um47Yf7MC/pcQMcpxlkQiPMbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/iC38qKUGdl7qsBIiXPA+JqilIvEPzYqGnN/PMSv2uyynbw2WksA2iGsqFA7OyK7
	 dudjbcA+FOZQj7T+BFOPQk0FMjFOjPfk3OUl7+XUsZhapTWkJekTp0c49+srIDYmm3
	 rvp3tgLiNpmUkMMteMCjkP10t0eH9fFqsGnkknlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 532/676] soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()
Date: Fri,  6 Dec 2024 15:35:51 +0100
Message-ID: <20241206143714.143807217@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c9f1efabf8e3b3ff886a42669f7093789dbeca94 upstream.

of_find_compatible_node() requires a call to of_node_put() when the
pointer to the node is not required anymore to decrement its refcount
and avoid leaking memory.

Add the missing call to of_node_put() after the node has been used.

Cc: stable@vger.kernel.org
Fixes: e95f287deed2 ("soc: fsl: handle RCPM errata A-008646 on SoC LS1021A")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241013-rcpm-of_node_put-v1-1-9a8e55a01eae@gmail.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/rcpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/fsl/rcpm.c
+++ b/drivers/soc/fsl/rcpm.c
@@ -36,6 +36,7 @@ static void copy_ippdexpcr1_setting(u32
 		return;
 
 	regs = of_iomap(np, 0);
+	of_node_put(np);
 	if (!regs)
 		return;
 


