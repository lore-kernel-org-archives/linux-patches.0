Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253D925EF89;
	Tue, 11 Mar 2025 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707645; cv=none; b=a6PlVggl9BAHs92JTMWzxWfWWiIecyYi8H2OzQ4decMM6UShYyqZqS7P4QbJ9LkTmQCojRYvmHjJtZG84b68Mt18PkCOLLsHD37hWYvawy2ntqt7OJgSRjDADoLkv9OfHEzPGUvxeaprCNCeJLo63/SkzCE0zPENEisMVIXAFRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707645; c=relaxed/simple;
	bh=jxegrlck94WitTi3oUMYWG5QfSQqiY66xGBLtiXMLlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLA/FFLuGk5Zn/ehy06BHsosv/TVxfGLK25E4/5xiS/VySKJ3gLAPUnkdjPq2yHUeet03O6wxZx+OX521vEYuhvK7Ltf9v9RNyw3WgvzWl+k1BjlP2SsPBxhqtNZbuKAgyTj05ZwruEStDSrJ5I1pR6Ppg3Qybv8EoT97b0w/yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtTHv2C2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtTHv2C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1017C4CEE9;
	Tue, 11 Mar 2025 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707645;
	bh=jxegrlck94WitTi3oUMYWG5QfSQqiY66xGBLtiXMLlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtTHv2C2gX3gnt9NcfXFhFWHkqM3qkrWelTx3+N74HVfhjaTn/KgDsteeOzmOls08
	 ztfmnS7L4ufOJIy1YkR9+vJ6uKPuNhErXFteBBFC25oq9D1g5g2sJuZA7XwF7k/K5h
	 G1QM4SrAP+AVCCj/dGxlYw6mPR/Oskk3cN3FolkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 5.10 460/462] perf cs-etm: Add missing variable in cs_etm__process_queues()
Date: Tue, 11 Mar 2025 16:02:06 +0100
Message-ID: <20250311145816.498568322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

Commit 5afd032961e8 "perf cs-etm: Don't flush when packet_queue fills
up" uses i as a loop counter in cs_etm__process_queues().  It was
backported to the 5.4 and 5.10 stable branches, but the i variable
doesn't exist there as it was only added in 5.15.

Declare i with the expected type.

Fixes: 1ed167325c32 ("perf cs-etm: Don't flush when packet_queue fills up")
Fixes: 26db806fa23e ("perf cs-etm: Don't flush when packet_queue fills up")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/cs-etm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -2171,7 +2171,7 @@ static int cs_etm__process_timeless_queu
 static int cs_etm__process_queues(struct cs_etm_auxtrace *etm)
 {
 	int ret = 0;
-	unsigned int cs_queue_nr, queue_nr;
+	unsigned int cs_queue_nr, queue_nr, i;
 	u8 trace_chan_id;
 	u64 timestamp;
 	struct auxtrace_queue *queue;


