Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057546;
	b=PNBQMfoRKRF65sELl0rb73yRNdA76wc6jUEMSKYTGaxYhoPjtQB7Fkf60nDAXdV6M5/D
	 wO1sbmIzMdA4uVLbb5PhUT8Shkj6e+WbpoBfL6d4l+JwOCxej+5SUZ3uAtKybLYB0NcII
	 HoOOboYfFTihElT8pv93ck3QzTItcLK3emWXiNwfS1sZKBOxNJn0bIzgvDkCrIV6v0nhr
	 8yTIPmH3OSPYauxt1eE2zpQBs2VYwQxJo8t9xZGnnhn3AFTW9pT/S+fp/6WBCuCdbgk0B
	 fWZJPqC5E4hmIX1toMvaB+C57K5Ag5fGJA0AELnzG4iP000ea6d16/8KtOhKAeMC3bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UICvHQ8wR7iAF76I6PUAZfhBzoipMXvI12kk3p9j+CQ=;
	b=PRBxLoewv18iGfKhHr88UEYlvSDp5k2ynLnvFWLIDsU50DTxumDhGnI5OXEF10Zeh0OJ
	 hH7jymFAbz5KjIo3+fkeONvGEHLbgUaY98WMoXX05RYGYhhcJzGe/dFtW0uTOYmLuOkiA
	 cCQ4AbRpRVGBl1vGw2JfAan7h65b6+OHEZqF/uWtetNNdtQ9DktjzvupISrCcWcuPD2LU
	 3FjBIOakBpC96OV2JcpsLQN15YHLSmnH5zHPfZNbtUVfSfik8UXt9hnSbXgdXFR3M7bT6
	 SPeA7Z9uRa4DvsubjW4BWsUC4dJa0VP96qU5eTEp6ajnxbJSvhGZefIT+LtywVXe+Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQbw1Idf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49280606A33F;
	Thu, 19 Nov 2026 03:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQbw1Idf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E10A1F000C4;
	Thu, 19 Nov 2026 03:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057546;
	bh=UICvHQ8wR7iAF76I6PUAZfhBzoipMXvI12kk3p9j+CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQbw1Idf50vNPdFiWuoeQ/+T5SxhRAC4I3+rFs60vG3X4yYgsoLyp5vw72+w5pYuR
	 aa2lYNg+SZEaP3hcIfvuKzu+8KLvdgoxzmUKfJnxjshlUpr/j9lm/npSguysnjx+0p
	 Jrdn0ezkd+PELYDDKRp08buyLSbRypUA4p8UQG38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0167/1848] docs: cgroup-v2: fix stale "io" controller introduction
Date: Wed, 18 Nov 2026 15:36:45 +0100
Message-ID: <20261118145918.625259101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 608d7c279396b..6506b15609324 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1518,9 +1518,13 @@ IO
 
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



