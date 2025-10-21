Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903A41A3029;
	Tue, 21 Oct 2025 20:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076977; cv=none; b=taCsQoJQII1zEVV5Z0eNqmCRFCH0mUdahjL+IBtrhHmsbLuvx37mBJh08Rn9w+FeNfRs6yiHBwxFdEiwcsUb1183LqC26L/cwKle2FqYNn4wOXpPGbnGirihbnZvZX+o9Pec4FzrAYH1GpwA6U825az0JS2Y5uRR2c1yh+Ootw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076977; c=relaxed/simple;
	bh=SGWZ001JtS3LyV+yjfGDTXS4JNMK5HPzQbsNsJ+ZEwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA4nbhqxJ8memSNGpRq6GKN8uXJRM1SRqJjvyWtos3HCGiUXwNPrDLflzovNxylfRqw40T4nr0qMipQzT8wfzpEa9Pt8SZ4PnWe+VIpwKFVqGvnwkS94h2DsLNM8/v2lvTuWyMs1mrMChZrFlbqti3w7wY1G43jzTpnUM0P7Aco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xj9NU/Ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xj9NU/Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AD2C4CEF1;
	Tue, 21 Oct 2025 20:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076977;
	bh=SGWZ001JtS3LyV+yjfGDTXS4JNMK5HPzQbsNsJ+ZEwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xj9NU/Ps7DxXDKfKlXTlmvynwNR07me7CboIRwLwvoIjBHEvskh89lfzkK8mw/Hof
	 9KDxHSIGDv60hUFauC+cAwLZ1+wrPRugmaZjwQELNO+ZAvCxrEmNAL4ADoMivOxykr
	 oHLvu3/CWAM0gteyWKPoI3Lamea/k209w+P5S6Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Guibert <philippe.guibert@6wind.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/136] doc: fix seg6_flowlabel path
Date: Tue, 21 Oct 2025 21:50:40 +0200
Message-ID: <20251021195037.231435093@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



