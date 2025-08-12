Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC602C21F6;
	Tue, 12 Aug 2025 18:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024615; cv=none; b=TmCoVU0HoEOOCVN5xu3Up4oux1iSCQNdK0I8dXQAVN+FgcWRgjIKTAFKZuBYhvcCqKKW9BYTrUrkXBm4kwUauh90a8YPyx9ZxWe0uMobKmmpM3VDWaU9WHgMXzhbHzACf6JEEPkjD9HFuvkx2mHIspwqmDZAaExTNbLtaQShVrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024615; c=relaxed/simple;
	bh=b6xFxq5lmmmaTO/4LbhNZMTcf44SM5oDDd/8mbkSlDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1+C0MwlEN47mlfSiPcClRcyQuSXwKYp+8pruCEz+MuZaD1lrrLJhuvKuc1ak6gfibPeQIOluk1TqWOvdgz6DdbYIFIFf6k1jABHUZST7wtpauAVgShQOrZ7ACfNGzW/riH+5GhtXmkV/EPO56oTiFWGGLnlr3BQmvQeIuhW+J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KldOWMel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KldOWMel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8C2C4CEF0;
	Tue, 12 Aug 2025 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024615;
	bh=b6xFxq5lmmmaTO/4LbhNZMTcf44SM5oDDd/8mbkSlDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KldOWMelmZMj0Aznfu6N/NZCDw5F+Jn8+c+asGmEvX/RjhwV1ffWkdoHN4UbGbFXQ
	 z6V66+n/3UcFlbHme/nUQ5D+0Bx+v2wUcRZSKqEYd1YlDSdZMEUTYnApP0tWEbyvYg
	 79BlEObwOtuSsNPB/QFF7UhDaM4YGLzkekLdIzBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 426/627] perf tools: Remove libtraceevent in .gitignore
Date: Tue, 12 Aug 2025 19:32:01 +0200
Message-ID: <20250812173435.472867728@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit af470fb532fc803c4c582d15b4bd394682a77a15 ]

The libtraceevent has been removed from the source tree, and .gitignore
needs to be updated as well.

Fixes: 4171925aa9f3f7bf ("tools lib traceevent: Remove libtraceevent")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250726111532.8031-1-cp0613@linux.alibaba.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/.gitignore | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 5aaf73df6700..b64302a76144 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -48,8 +48,6 @@ libbpf/
 libperf/
 libsubcmd/
 libsymbol/
-libtraceevent/
-libtraceevent_plugins/
 fixdep
 Documentation/doc.dep
 python_ext_build/
-- 
2.39.5



