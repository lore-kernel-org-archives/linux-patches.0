Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BC441C62;
	Tue, 11 Nov 2025 01:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822820; cv=none; b=jigJVgBWCqsaWtY4nrb5pAl1+2QpNSWQt6nss0oBxiEoiP2YSwhg3gqMs2DirSFfKxL/I+D45cxA7WwCLXLDJV755lmCiw5AQ9gNsxR87KvSZclvFFd3N/Irsl64adKrxp065Q5W7/RGRFcElGf/AKRtvDfyomMp4cVbRtP47FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822820; c=relaxed/simple;
	bh=p7wA+0y1UPxL9l3yJ/sP+dsnJmmOAWS0T/vO6zpZsuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4iKfaWugQXUEFuPJVnOIGu1BZlCY/RWckApK2v+LTsXm90+2Mv+T2MpN2rPbUMJtKg9fTq9JCBxDRbjybX12KyJP1vEvc3savH6n8FiXCX2EnZyNV2W0jZwVCzplvW6VfVEIbZpXOm6ZKizaoBIERVjEss2HVgo45h9VWoPMqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtoK2EyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtoK2EyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64039C4CEF5;
	Tue, 11 Nov 2025 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822820;
	bh=p7wA+0y1UPxL9l3yJ/sP+dsnJmmOAWS0T/vO6zpZsuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtoK2EyMpau1k7VStk955R0U7E2vOpZIUXAnn8EIxUWXraRgO6b+hJvAEIBlzrxLz
	 5ofGuQS9Jg+gbMrnsaB5HO0JCHVlKQyUn8dZ4OlNNrq2Vs049lSuhm50vPyXDUWIpA
	 luIjk0ulTzpsvaNmrIxq2bgqRYyl/R9ziCF9PRrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/565] thermal: intel: selftests: workload_hint: Mask unsupported types
Date: Tue, 11 Nov 2025 09:39:31 +0900
Message-ID: <20251111004529.543376478@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 0115d063559fa6d25e41751cf455dda40aa2c856 ]

The workload hint may contain some other hints which are not defined.
So mask out unsupported types. Currently only lower 4 bits of workload
type hints are defined.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250828201541.931425-1-srinivas.pandruvada@linux.intel.com
[ rjw: Subject cleanup ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/thermal/intel/workload_hint/workload_hint_test.c  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c b/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
index 217c3a641c537..ecf8b06c1ddf6 100644
--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
+++ b/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -146,6 +146,8 @@ int main(int argc, char **argv)
 			ret = sscanf(index_str, "%d", &index);
 			if (ret < 0)
 				break;
+
+			index &= 0x0f;
 			if (index > WORKLOAD_TYPE_MAX_INDEX)
 				printf("Invalid workload type index\n");
 			else
-- 
2.51.0



