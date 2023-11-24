Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DF42EAEA;
	Fri, 24 Nov 2023 18:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZtWMKSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64E2C433C8;
	Fri, 24 Nov 2023 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850885;
	bh=gHSrw0UDyPnqTFLddK0ARoO+cbaqqpTLQ+AdxAlIkmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZtWMKSU+VBMo1fdytGjGtAs4FgLZVPRRK5s8j+hnFPsgS3ySX1D9AzYeMz2A0OdB
	 /SYBcDUXio/uQxNganE9/oF++GiyALqWAeI3RHPCFJQgiI6Dx7y57JEqh0JQWGOICk
	 GHD+78EFhLcsnB8jzbWgGk+aDdHDy8nddoIQQguc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.5 228/491] perf intel-pt: Fix async branch flags
Date: Fri, 24 Nov 2023 17:47:44 +0000
Message-ID: <20231124172031.409367419@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit f2d87895cbc4af80649850dcf5da36de6b2ed3dd upstream.

Ensure PERF_IP_FLAG_ASYNC is set always for asynchronous branches (i.e.
interrupts etc).

Fixes: 90e457f7be08 ("perf tools: Add Intel PT support")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20230928072953.19369-1-adrian.hunter@intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -1512,9 +1512,11 @@ static void intel_pt_sample_flags(struct
 	} else if (ptq->state->flags & INTEL_PT_ASYNC) {
 		if (!ptq->state->to_ip)
 			ptq->flags = PERF_IP_FLAG_BRANCH |
+				     PERF_IP_FLAG_ASYNC |
 				     PERF_IP_FLAG_TRACE_END;
 		else if (ptq->state->from_nr && !ptq->state->to_nr)
 			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |
+				     PERF_IP_FLAG_ASYNC |
 				     PERF_IP_FLAG_VMEXIT;
 		else
 			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |


