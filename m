Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9111F75A6;
	Tue,  3 Dec 2024 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239794; cv=none; b=S/DKTyfN2swL/cK5MYVFSfA4+cYbNOxVaHQ7Z5jVO+RZQ3v5/P+xVpihXv6bBoK6wt60NIO8DjnsmElSPgDEs5CqzfK5cSKz4fCYTaBNfq5Mv6h4kg4VyPweNVI9nIIRzzxIZwV+vbVD27oOw1w/6+lly9kTa1V61rMTFSZ0Ut8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239794; c=relaxed/simple;
	bh=fD1BCtVg+GNH/oWDstyAI+KOOD/Hr3I6o3qrg5CBvu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiciiM9qW/hr2OKhxnOK3TSn+m3u7BLdlewJsC782cQBwOvgnEz3CMpAkm585mF/Aunq7pyE8xOehFfW5+vTobRLyXfF5ZWV+i6gzkpcGWwlIyOpdtjLB7eidTl90zvjEjvjH6kvc08DdTl5tMTsLRRSBrWwMu1MqaH2KIl9f3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfgIru/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfgIru/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5606EC4CECF;
	Tue,  3 Dec 2024 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239794;
	bh=fD1BCtVg+GNH/oWDstyAI+KOOD/Hr3I6o3qrg5CBvu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfgIru/hNmoNpzw0DPBAjCsJT5qwhixouyP0HzrlLojqu0z6PlyyehoVw8Vt1GWex
	 U3Uj2fTvvBxT1s3oQBmIMj7lAA3mex8MMdhsKrulw/LWFsMvh9bQFtwTwCMm+la8cf
	 1bIpP1JrfGzUKHcaOo2ZK3QxXtFm8nRfN7/v5uxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.11 736/817] soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()
Date: Tue,  3 Dec 2024 15:45:08 +0100
Message-ID: <20241203144024.728299077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


