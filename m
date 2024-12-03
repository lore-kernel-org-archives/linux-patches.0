Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ADF1F8912;
	Tue,  3 Dec 2024 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242546; cv=none; b=uu6kh8m8cisMSLffSMegqapa42ntuXKbTirLHRP7uBornUJk6unvF+JXq6dlfw2B5l5WCOexo9ne7EyEgVI0vwHwxm7hXk1wb9piD/CqrQCJ31Cyn5V79EoiaLon4cKH8Uj2HlI8pa2FxKD9RBMlrPVTX9Y7eiwfHRWc8FW8DD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242546; c=relaxed/simple;
	bh=dnWMmveqv87wK9Byky1qkb1Cwe3pbz6EwRMN3eOtKMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2Fo4PynWKm2w1082+fWK2o+KTNCFnE+MeVaRw5xmboWmIBkVSV4cy2Ao8ZFTU7ciNBGPaSu8DUkpvQM8dfPiMQVjdUVOF6YPa3o/klr+dKWacn7y9KqedF9f4/KJeG7XKZflm3WW8jhPeKzF2UQwNe2V5RK3DmYNVxGkmFV1aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHLgp4qT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHLgp4qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4B9C4CECF;
	Tue,  3 Dec 2024 16:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242545;
	bh=dnWMmveqv87wK9Byky1qkb1Cwe3pbz6EwRMN3eOtKMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHLgp4qTOJv0SSH8EOZY9M6rnJkq5dv2X2MoLiyuIl8/QGZv9DzTDWupnafjxBStp
	 yl8BFZdfjzaJnIst/eUFtkAVbR1h7VICsrmeTQFJ85fPGUkbJR4gSZkL5P6Egog7m+
	 FsWmY/z5X0NGfIPuGaQmfm5eE7qQNjzy2OQFdPXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.12 736/826] soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()
Date: Tue,  3 Dec 2024 15:47:43 +0100
Message-ID: <20241203144812.476346279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


