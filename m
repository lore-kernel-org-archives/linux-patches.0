Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031124;
	b=l9ujQw2vBy+L4OfySWjQtAL9ayoPJZZsf+YOxIojsjdNIEkPtuhugDAFhg9cbEFiM2fR
	 c9DzFkolL5rguIbxXZB2oJf4UpnAJXA/SGqUvm+oCh40XnzSgrRJ/OsHntJo4E+Loz8E2
	 SRiWIgGRrxIcLMrdp6otEjek8Rvaz0HINytvW4DDTE5bGqSGB2BaX47wP0u/tbeiYt6YR
	 sMhIQ3y0oEJm2ddgeYLEyqjfl75SDdFMUfc5ZjNqqraWxqs2iAebGCxcATyesyWAHwTqE
	 4bubkkPNNoxqhgSNzr+w4O1REftgaqxnwc9fvVWfbAMvjELf6Qhnp3zpMODT2rZ8iWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0gOACEkwvm1j448cWklq32a1fL+gBIfcAKl3HRAQuy4=;
	b=qHcb6LR2DuElkjMq2V2AEsP6uPFZAi9CfK5BaC8IubTRuklaYVRt7XSV/MVbqJGTa8xF
	 vzPA2xNacZHV3wSH12ijOnFOPpeeQTfisIVd7YT6wdRfFSMaTlLFh+O7QLC/LaYNC6Zzv
	 In7sSa2RFeXRYWob5mG4BqGf/RTm9HHzfzBHzROrwnPWX9X/Bmv/PQ+1eCitY6Df6Jqpo
	 4kPyq0UXEloUHFSom/whNcK+/8NRDDUpGVGaxmGTfcUyo3lYKgG4Hd6ZscFa2xY00s30G
	 9oVATDn5ndIFXotT20q548d3xocfdCBQGaOgXWW5CQ4Bam3kpGekfhme/sBUygN9mQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5xHxtwx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A46D606A32F;
	Wed, 18 Nov 2026 19:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5xHxtwx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707A91F000C4;
	Wed, 18 Nov 2026 19:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031124;
	bh=0gOACEkwvm1j448cWklq32a1fL+gBIfcAKl3HRAQuy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5xHxtwxMCXo92iSTf27L/AtTX0L+X3J+LSUZL4pV9wjaV13mhKePFV8Z8bQ9CgaS
	 hMZ0JiC3GzonPwYbaWZFCzVa5fc6lMTxNO/9o5uM9gAcXpfCuQo7BrRyb/5N1Xb/kX
	 jCQ4vU/5iSVqRXVgGWsMlUpXLDdumKAY8h503E3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0947/1756] pinctrl: sprd: free maps on DT map failure
Date: Wed, 18 Nov 2026 15:51:14 +0100
Message-ID: <20261118150047.780534662@linuxfoundation.org>
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
index c4a1d99dfed04..1db542731a1c7 100644
--- a/drivers/pinctrl/sprd/pinctrl-sprd.c
+++ b/drivers/pinctrl/sprd/pinctrl-sprd.c
@@ -329,6 +329,9 @@ static int sprd_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 out:
 	kfree(configs);
+	if (ret < 0)
+		pinctrl_utils_free_map(pctldev, *map, *num_maps);
+
 	return ret;
 }
 
-- 
2.53.0



