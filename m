Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EE2737E7;
	Tue, 21 Oct 2025 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076453; cv=none; b=Uij4NlayL+r+V2AnR+NSql5treomnm8p06h+XLtdTHDL9laigKvHdWCFRTNy2yWniNpMvmqISz2FIiSp7fq2XUP+Z20lqgXzV9nG1I2IcliHfiqWQz4hBLFKMej24Fde055OxQDaUuKhr8s7BUXWgZfTXFozAWfUTKsQWrtqjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076453; c=relaxed/simple;
	bh=CcIPFdzpstwgFbI2hfer++3mBgDQ0VR+ZrQDSQ05rYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh1j1OMQ/S1jzvA+2sE3+PIFge0nzVKzG/qEv5MA3YNL9wJ2D1HRBw+qXhGa2yuCWgp6chqIXr5XAs2gaH1SH2A5hL9MF8+/M+DNf08PDv308FUHCqie9vuMooW6qj+9VPQqDggdkocW13GivnTn98JOsyY5lPGuBUhSRX0fDK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1jRAfv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1jRAfv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960CEC4CEF5;
	Tue, 21 Oct 2025 19:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076453;
	bh=CcIPFdzpstwgFbI2hfer++3mBgDQ0VR+ZrQDSQ05rYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1jRAfv6SkSst2JigiLU3iRj1HySUL9OL2aFBbxW20DEMYB6lH3cp5Ldi/+WshFn2
	 pLRoUVSrRZAn8akD1QddSOSNCZZJORmPQ5h0hMkIijq6GNxnwVArBgP5pCZNMeS/l0
	 BsdYbgH8gxC2s9INmf11I5ml7uyOrJvfGZC0CgMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Guibert <philippe.guibert@6wind.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/105] doc: fix seg6_flowlabel path
Date: Tue, 21 Oct 2025 21:50:47 +0200
Message-ID: <20251021195022.595139171@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 0b4b77eff5f8cd9be062783a1c1e198d46d0a753 ]

This sysctl is not per interface; it's global per netns.

Fixes: 292ecd9f5a94 ("doc: move seg6_flowlabel to seg6-sysctl.rst")
Reported-by: Philippe Guibert <philippe.guibert@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/seg6-sysctl.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/seg6-sysctl.rst b/Documentation/networking/seg6-sysctl.rst
index 07c20e470bafe..1b6af4779be11 100644
--- a/Documentation/networking/seg6-sysctl.rst
+++ b/Documentation/networking/seg6-sysctl.rst
@@ -25,6 +25,9 @@ seg6_require_hmac - INTEGER
 
 	Default is 0.
 
+/proc/sys/net/ipv6/seg6_* variables:
+====================================
+
 seg6_flowlabel - INTEGER
 	Controls the behaviour of computing the flowlabel of outer
 	IPv6 header in case of SR T.encaps
-- 
2.51.0



