Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF12A25EF80;
	Tue, 11 Mar 2025 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705362; cv=none; b=k8NyheimYfHR4G6UgRdVLjRFOugcAFqX5SgbJtELvel5Xp6nJc0TuoZ7RgQsTfa6fWeLVnk2Pk5VGkzK+PHpYT1pb9kYTI1LbWjT1vk5qbr9cTf7G91+awgA5bSMZgJkxu5nYbKII7yT8znLCF02QG5wH+b8UNN9io4o+xt/Jkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705362; c=relaxed/simple;
	bh=Cv8KzLnl43Lg6bJwU3FSU6My9ifVrq3bAbiAeTRAhDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8ZJ2cRESRmDEsDp1IdKEWLDT2oyercgYD8bB3Qn0Fw49N5s/5S6ZifpV14GI9XxKiAhivS2pqhpe1eJTFLa033T5jsQ+YLVGEMnpn6EJgVnmRG11uNvUxUl8Cipdx1tNZlBSUeqKXNE3jSH+s+UNeUzG7NocdRTwONrAzoN2g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ij0YzTET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ij0YzTET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78CFC4CEF1;
	Tue, 11 Mar 2025 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705361;
	bh=Cv8KzLnl43Lg6bJwU3FSU6My9ifVrq3bAbiAeTRAhDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ij0YzTETV6CW8/Yt+YHeAKaWDkaD7H+krLvgMhIFlUl8W0FRnZQmGAd192OGZ/ZB5
	 2ph1vTYEucQfrXu2+PH5LAkKeubAstjHZCOOFxPib3JSQKVmcK/AOFuTm2djS0U8gY
	 KF8We7Wt1wkK5FnQQSd6lWMVKRB1YPFLeNZLb3io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 5.4 001/328] perf cs-etm: Add missing variable in cs_etm__process_queues()
Date: Tue, 11 Mar 2025 15:56:11 +0100
Message-ID: <20250311145714.930815871@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2139,7 +2139,7 @@ static int cs_etm__process_timeless_queu
 static int cs_etm__process_queues(struct cs_etm_auxtrace *etm)
 {
 	int ret = 0;
-	unsigned int cs_queue_nr, queue_nr;
+	unsigned int cs_queue_nr, queue_nr, i;
 	u8 trace_chan_id;
 	u64 timestamp;
 	struct auxtrace_queue *queue;


