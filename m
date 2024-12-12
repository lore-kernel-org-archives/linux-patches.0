Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8379226863;
	Thu, 12 Dec 2024 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022812; cv=none; b=C7XudF7o7ACi7Lsuv+Ia5IcTr9GGGcfKWuTTG8xH+Xwri08A4MUCWgTY2AJ/48Ax8u9hEO+hn2hHf1txPyrOnmzWnUqcLLiIBOOCOkrdlwDGKktejnL6ymbfF78M0vD+Ls9fK1Im8cYSAU8/UkyB/9CmeNILqThWZUdsJHjm4Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022812; c=relaxed/simple;
	bh=L71/LaJPMpbjlIvWekaRt7OaD1MWJnhwkrztYYjp52s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYcjzLJDiAFfHtxHyiBgDlv8z6xXQMfsEhKVRraydpup/0b1CLqqt0CH3hqrZWfsrwj3yMHSGuw15LtzWKcdqQ/nrfJm3kPXKYht+eCEcU321CCtvYyMPQ1oStsqPDqsh/GbTYRYUkJC+PHLdCBIq1GtYEtEFgpInOWYAShz1ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1QgYnaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1QgYnaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD30C4CECE;
	Thu, 12 Dec 2024 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022811;
	bh=L71/LaJPMpbjlIvWekaRt7OaD1MWJnhwkrztYYjp52s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1QgYnaK7ZPerpnsktkUDDNBwtksCKciuHtTKTgxbCGxhtmt/JjpUCP/DWfou1V9M
	 Cvr/HSDKwY/U8cNWEYyTCsO+Lz0+bcgBdVS1w3AtTARr5HJtZ1VYeT68R3eNMC6V7A
	 oByvinoSIo9GFj4RlhWF0J4xQPyYQLJtxJxmYASw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 5.15 341/565] soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()
Date: Thu, 12 Dec 2024 15:58:56 +0100
Message-ID: <20241212144325.076059702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


