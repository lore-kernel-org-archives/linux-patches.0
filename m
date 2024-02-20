Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AA11509BF;
	Tue, 20 Feb 2024 21:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463653; cv=none; b=qrYSYjImsv7MLTGS05lSkUAH68asemKgk8m8yi9t+spLRYqVRTR2ah5KE5bfnEo6UaDsr/dhp1TCwQL8RZuPLeqG+drOSzeyeYznC1l6yuwef70dm944PRXeiLHdpuFkO8eMuCUTTHzR/wqG8K0i32u6P4kmcmrIpojMT1FOD5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463653; c=relaxed/simple;
	bh=dQv3HFFhibXVd14DEHU2lPiYW50+Q53LcsECNqKXZAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdS4vDHGbZ3PCGuhx6o475JVC7jJc3y3Z0Ukvj+53pXoBvBc2gcH4oIF3XxWt0a7UIOP93kMPL62wq90rKnOFPSMjoh1liKPqhMRqxz0b/gV3a3iwBHMgIfLRF5OlIHObWbc8MDUW+Pfd1p430PLLZ1yS1eyf0BUgosfEkC2eQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2DzSVry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2DzSVry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ED8C433C7;
	Tue, 20 Feb 2024 21:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463653;
	bh=dQv3HFFhibXVd14DEHU2lPiYW50+Q53LcsECNqKXZAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2DzSVry5GQsQWBoh59iwlMfP+J/4Zy19eINuN/CTOZc4WOWcFYLsoWTIUE7tzJCR
	 CJjJXhXGUqSBP/KxXJPZZ4r4WarX5fiuxtQr8saESfmcSjZMF1zAc3IodZbhpAYUH/
	 r40jEMI5SlHMIkX5FBkoW1pCQaii3DTg8JA8LVbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 110/331] selftests: mptcp: allow changing subtests prefix
Date: Tue, 20 Feb 2024 21:53:46 +0100
Message-ID: <20240220205641.069200737@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit de46d138e7735eded9756906747fd3a8c3a42225 upstream.

If a CI executes the same selftest multiple times with different
options, all results from the same subtests will have the same title,
which confuse the CI. With the same title printed in TAP, the tests are
considered as the same ones.

Now, it is possible to override this prefix by using MPTCP_LIB_KSFT_TEST
env var, and have a different title.

While at it, use 'basename' to remove the suffix as well instead of
using an extra 'sed'.

Fixes: c4192967e62f ("selftests: mptcp: lib: format subtests results in TAP")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-7-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_lib.sh b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
index 022262a2cfe0..3a2abae5993e 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -6,7 +6,7 @@ readonly KSFT_FAIL=1
 readonly KSFT_SKIP=4
 
 # shellcheck disable=SC2155 # declare and assign separately
-readonly KSFT_TEST=$(basename "${0}" | sed 's/\.sh$//g')
+readonly KSFT_TEST="${MPTCP_LIB_KSFT_TEST:-$(basename "${0}" .sh)}"
 
 MPTCP_LIB_SUBTESTS=()
 
-- 
2.43.2



