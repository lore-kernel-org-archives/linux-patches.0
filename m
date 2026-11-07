Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060953;
	b=YKYpDaseoqeVoIzSEySKkKot+E2XNAGiGVGgFZfsubLeDbOJeSXlIACE5deD0rFPY7nY
	 5eHTDkVOYaxg+t0mDRJp8agsmf5+HmHeO0wLuBUDxIv63ggUzLYDI2q+PZ+DB/UW/BFrV
	 GttReJH4aWkG3idQJTjkQHy1moFwT+SL9jD01o4utxYW/hls7/S8ZX0UK1zn16nsapHQ+
	 K7jDVcCb7IiW4YB4sYKv4vY1mDPzWPAHhk/Ubin/l8fPqEo11pnch2CBqA3Mm95dqO1n0
	 FqV9zp/qKZrgJObVJ/u5W4A4ZYr0B7gR7AbJMy759SjRH09VM1wlAlkEgtf6NPP73bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NTdyMteTWCeSlpaE7q5Lixp8JTYTbzOp6S8yJAFYN+c=;
	b=jsjXox2kT7YgtcvuxMCR+8PdBJjhaUbA9HsCmkoi1dDNllfW49r3ZfCw+oNff/BpHEXe
	 uKPLONb0QRFQ+GOMK23J4snSgUQHGs45Offh+IufNTNfdmXUVapYsX4RFSE5AArv8ut8L
	 0jlg2TTN3+O2n4LnwYcvTiKbX+YKtuW6CVeLjN8YPI/t3RDeV4Bu2S7QS+hqbg44RjjTH
	 ngLXAkuMgW6fHxb6DImpg4lfy5+pK86yfYfOxY+SsCxpcBdRttypdJNILP6+i5Lu/FMli
	 yMceTtAMyamAfQc9e3LDdEf8tTMknkQyUScZLgh3uMK1EbFFasVj/FTQBkxtx2mp5jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QuzNAA7R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36E9606A33B;
	Sat,  7 Nov 2026 14:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QuzNAA7R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F41F008A2;
	Sat,  7 Nov 2026 14:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060952;
	bh=NTdyMteTWCeSlpaE7q5Lixp8JTYTbzOp6S8yJAFYN+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QuzNAA7RbN9PJ1WmMxG0yXYCBuHIT5gdirAA4lMlzZjhb1jZx+hWbDAPdopdMN4Rx
	 eMsm7F8wdDwFluyvjwl9YMqVTvgq7k3lu9E8gmAOCb0kRhGu6ULV8bniJhXImWGxFP
	 APToEaXXocdqaj+w+2ZilOynLFaNcHCPUXHiCFsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0311/1536] docs: cgroup-v2: fix stale "io" controller introduction
Date: Sat,  7 Nov 2026 08:38:47 -0500
Message-ID: <20261107135006.457170656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Zhe Liu <liuzhe1@kylinos.cn>

[ Upstream commit 3345c7248a9e2a91cb9e2477c29af16881706f4f ]

The introductory paragraph for the IO controller still states that
weight based distribution is "available only if cfq-iosched is in use"
and that "neither scheme is available for blk-mq devices".  This text
dates from when the cgroup v2 documentation was first written (2015)
and was correct at the time, but is no longer accurate:

  * cfq-iosched was removed in v5.0;
  * blk-mq is now the only block I/O path, and both the absolute limit
    scheme (io.max via blk-throttle) and the weight based scheme
    (io.weight via iocost, or io.bfq.weight under BFQ) work on it;
  * latency based protection (iolatency) and I/O priority (ioprio)
    controllers have since been added.

The rest of the section already documents io.weight, io.max,
io.cost.{qos,model}, io.latency and io.prio.class correctly, so the
introduction is the only part that contradicts them.  Rewrite it to
reflect the current state.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 2cb58daf3089b..8aab1c3b48ea3 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1833,9 +1833,13 @@ IO
 
 The "io" controller regulates the distribution of IO resources.  This
 controller implements both weight based and absolute bandwidth or IOPS
-limit distribution; however, weight based distribution is available
-only if cfq-iosched is in use and neither scheme is available for
-blk-mq devices.
+limit distribution.  Absolute BPS and IOPS limits are enforced by
+blk-throttle and apply to all devices, while weight based proportional
+distribution is provided by the iocost cost model controller
+(CONFIG_BLK_CGROUP_IOCOST) and, when the BFQ I/O scheduler is in use
+for a device, by BFQ's own cgroup support.  Latency-based protection
+(CONFIG_BLK_CGROUP_IOLATENCY) and I/O priority assignment
+(CONFIG_BLK_CGROUP_IOPRIO) are also available.
 
 
 IO Interface Files
-- 
2.53.0



