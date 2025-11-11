Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C90B4C97;
	Tue, 11 Nov 2025 00:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822706; cv=none; b=cg8iUW4uj59LcJOVIPGsM2HGNAHMG8SZnwkxDrqr0tA0JVQ3rutqupa6dYqPHMTaRsUp9/ZtueL9p1YAsUBXJ/qr5Lz1UqKZJ/+1EXQBIUbQA4/LppLK/5GxRsXEPul01K+PcERH4LgUraDldUOuPB6jjXf/nPgoka9YsCon9AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822706; c=relaxed/simple;
	bh=wmzvZEFcGS7irPOLEt0189XyxHbWMPuzrJ9uJQ9Tk0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvu2dVn+SrL/LbuKFYyMlFPFD4zA09cbMXbt0kHzEEcNRnliZwoe/LtsQH47G2Ts7POv/FNO+g1zKsg6++xk9ySI2Rd9bLWtL9RVIvCwomqCoaI1+T6iRlbNgprJ5OdectSO0tdYR0ug2f3GjXiZaxbpI5MiKEVRoNtGcSQeMkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+rnQWnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+rnQWnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1247C4CEFB;
	Tue, 11 Nov 2025 00:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822705;
	bh=wmzvZEFcGS7irPOLEt0189XyxHbWMPuzrJ9uJQ9Tk0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+rnQWnEK4rp7Xeh3/mwiK66ZeUTX6e3vvkmqJPmumkl0cT6mOAiGgtzndXapukeH
	 jEVx6Kh8/PkmCOLqEzG3olQ+qcGgGgB+LgUebEwSyU/nl1GfOwbVkZtbiVHODkwwd/
	 n0MufYk+TF47IM6DxmIVOY+XobykjoLyYZL/8Qxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 152/849] thermal: intel: selftests: workload_hint: Mask unsupported types
Date: Tue, 11 Nov 2025 09:35:22 +0900
Message-ID: <20251111004540.096973251@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ba58589a11454..ca2bd03154e4d 100644
--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
+++ b/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -144,6 +144,8 @@ int main(int argc, char **argv)
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



