Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848AE215764;
	Thu, 12 Dec 2024 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020225; cv=none; b=jMME2MpWi4lS81G4Cp7n+CXgjcyWxMlvnLlCwg2OzrcY3pkUBi04PU9qKzR9iw+ZQTanokt8poY6YPWl5u8X8VN9USM8K3RZmkgtIdOMFzxSIpMo2ayElooIie11+rvnSW4ju6g8erC05TWLq/+lSxM5cS5aQtBfMz9bIWapy5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020225; c=relaxed/simple;
	bh=HkBVQt4pJAYbAOhlkYb5xf889dlJxSTz4KRvsiEAEtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPaES2PD24hp9bwQ9CTNDrmGcJ+v3I08NjBVXRJkz8DW3RTl0omFugwXFPF3Xj1nElJ/Ta4P7ufzA7FogeUxS8x6ynHKCXYt7qEA2y42hWuQuz8qz+fX0ha64ORy0nnJrgBdL8XND3c7LHKNMDM3lPnAM83YVBjvmFpaHItJH/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rv/XKpY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rv/XKpY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE682C4CECE;
	Thu, 12 Dec 2024 16:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020225;
	bh=HkBVQt4pJAYbAOhlkYb5xf889dlJxSTz4KRvsiEAEtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rv/XKpY5p9E+NBxY4LfNTjTwDw4U608qRmw6YivybJLFHXYR/3F6S3xagPNb5LWVV
	 yKvI60YBDLFSSJCxJKjA+Rx9tPVsg7/B4jMNeBL8zkVEjC4zMUQCIXt4UUne6UYrm9
	 qySwFqrg50AzO6KF8r/+/IYLWBMVZpojqp8agNck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.1 410/772] soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()
Date: Thu, 12 Dec 2024 15:55:55 +0100
Message-ID: <20241212144406.865799121@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


