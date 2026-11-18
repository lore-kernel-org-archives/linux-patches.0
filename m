Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043488;
	b=h6PutGnQO7xeeq58sKeU0D1sZRmW8npC/qpvlVYVjgAyw8x4PBFyJqGomAVNuHyYt0H0
	 xAiuJiKlkcwc0/81S2KFZ7iDkHTvaKYB7mU6/hJz8yy6cKDJeCoVBW8CdMy8qYc9DbgDU
	 iqnbK33HQcmVbjL7DvACm7/97Yu31r3Xge+xQ9833IVWpOrd1nejDa3HN7eeZOxEfNHz4
	 QiURp94Ny1HyNjbEn4Bq2X3XH5j80119Sh4Hny7+/v1/U8gTVv3UuwaBszGopuG6pt4dN
	 I+KC9Vt9RbKlAgbvFyfsb3fyMWsbHYSBXJkLUturKBTS0MAkeGKRUUUWSm/d19VmyOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsW/hk3ZXDoyZ4ImWOM/FSfMVK0Dwdlamnu6ejsYBMg=;
	b=wqUgHUdpbeF71XU9D47sAnaGRlmKXPjl2jQUWYbJlZt0gz5bUorRs5byPj2etm6gQcZJ
	 Iv9h17GUV6EDyFX6L6uh0bEBvOjE1CdeQVcogFap3eIDU3WoHSvH0VWzT7PRFd0DXaEn7
	 ExlZ3Z7VZSaVjXUdQMGMc4q0dh9GBVW7HhtMaBUpykX0U0I+n43Q8pmW0E84v74Tc3f65
	 k6d74SqGr2rCXSMYfhtXFNhfHY+x+WPPRuvto8+eKdQkXZHsf93XxI0G6x9eeNjR9dHQj
	 18x2wihnrsBvEC+ksLWR5XpfG3aMTbtUjf7/ecYkidxeTEFkYHUDA88nDL6OfV6hqCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMWzuenQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF097606A335;
	Wed, 18 Nov 2026 23:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMWzuenQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C7F1F000C4;
	Wed, 18 Nov 2026 23:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043487;
	bh=IsW/hk3ZXDoyZ4ImWOM/FSfMVK0Dwdlamnu6ejsYBMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMWzuenQkNDFB0sHeK9AXtpjR+MeHffZkzrrXZ4V6GOuMNR3fNGsLygwnQsOTPMsW
	 BSXxlmWYnL13TM8PFgN+cvq/pJI1i2qE56mQ1oWNxhHIXzarsoWjsyqZjb5TBHJcn5
	 9eB6SJxRpFUwBz4or0bZ1UvXW+eZmJ23IBKwx3I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0227/2857] docs: cgroup-v2: fix stale "io" controller introduction
Date: Wed, 18 Nov 2026 15:21:01 +0100
Message-ID: <20261118150209.632495843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc254a3cb9568..2606ed6423067 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1675,9 +1675,13 @@ IO
 
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



