Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED06246789;
	Tue, 20 May 2025 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749717; cv=none; b=oJCjlQigbjpiO1BWj+PVjWoWWLJumVDTCkPUtUDFDcCCalJPE+xqb/H6pZCqoEVlqjxXNkzcOV9hK/tt/hYAZvc6iuqI5HI+ikreWgPulHnFHMrufOMOH4NQilT3Y39AJnNN/eQVmgOUv6mKspBnSGtdpdbP2g12ypVF97m2N9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749717; c=relaxed/simple;
	bh=aiMgM5s51YhmY2jkfTbJ58piF2q1Bfqx/XTb7L2Aji0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5E9ORGkpmam2R1S4ZmCO1+EjWC5/LivAjF/Pa3et6S3j4gqZaSXTavnKbo/gXTHNkADv87/VK45LiQaOdYxXZbdTib4M0z6e15enA73m7MlUb+qLqAO6m1HfJPmFpaE3xr9u7rQ15pR1DdyuaItRxDAiWBo8Z48KJeJaLj9wHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6V5iHU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6V5iHU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158A9C4CEEB;
	Tue, 20 May 2025 14:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749717;
	bh=aiMgM5s51YhmY2jkfTbJ58piF2q1Bfqx/XTb7L2Aji0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6V5iHU0Yg8mUCHObqfxvIMfujXgSTcAFMlDyAVRililSmFaCNy/9+vtlKyW11h8O
	 K5+eEDiBHyaoNqrcusB2Oxg7D2ND8SI+EX+2sKzLcM+3XIFz4G2hmHWTUlMYuqxV6i
	 LWNOHkAh/Js+vuaZ0Dk+oMDQaJ0RMGYL+PStLLnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/117] tools: ynl: ethtool.py: Output timestamping statistics from tsinfo-get operation
Date: Tue, 20 May 2025 15:50:02 +0200
Message-ID: <20250520125805.465113308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 2e0e148c727061009d3db5f436f51890bbb49a80 ]

Print the nested stats attribute containing timestamping statistics when
the --show-time-stamping flag is used.

  [root@binary-eater-vm-01 linux-ethtool-ts]# ./tools/net/ynl/ethtool.py --show-time-stamping mlx5_1
  Time stamping parameters for mlx5_1:
  Capabilities:
    hardware-transmit
    hardware-receive
    hardware-raw-clock
  PTP Hardware Clock: 0
  Hardware Transmit Timestamp Modes:
    off
    on
  Hardware Receive Filter Modes:
    none
    all
  Statistics:
    tx-pkts: 8
    tx-lost: 0
    tx-err: 0

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Link: https://lore.kernel.org/r/20240403212931.128541-8-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 45375814eb3f ("tools/net/ynl: ethtool: fix crash when Hardware Clock info is missing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ethtool.py | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ethtool.py b/tools/net/ynl/ethtool.py
index 6c9f7e31250cd..47264ae20036b 100755
--- a/tools/net/ynl/ethtool.py
+++ b/tools/net/ynl/ethtool.py
@@ -320,7 +320,13 @@ def main():
         return
 
     if args.show_time_stamping:
-        tsinfo = dumpit(ynl, args, 'tsinfo-get')
+        req = {
+          'header': {
+            'flags': 'stats',
+          },
+        }
+
+        tsinfo = dumpit(ynl, args, 'tsinfo-get', req)
 
         print(f'Time stamping parameters for {args.device}:')
 
@@ -334,6 +340,9 @@ def main():
 
         print('Hardware Receive Filter Modes:')
         [print(f'\t{v}') for v in bits_to_dict(tsinfo['rx-filters'])]
+
+        print('Statistics:')
+        [print(f'\t{k}: {v}') for k, v in tsinfo['stats'].items()]
         return
 
     print(f'Settings for {args.device}:')
-- 
2.39.5



