Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042833;
	b=NmH5SU5lz7c2jbZXzt3TqWsGZpq+j5pBu5srPoHhhT5RC21/HIq4zlZlfrUTNCSdI5+x
	 pnTQeS3dWRcFFJY8HIrWXeV7Jor6HS6j9nDfXnoq1D1hRZ/UjLKY3SDdRfErz++wEN8bM
	 UkwBZl9msULcoSkVSEpP9WAKqxK0AOnr6cfhtCN7TCcXcagcZN62JnaJNWvdh9BzBPPmR
	 0pcq2kiC6s3UakIUcVJJyaDXdC3YpERmGYJK2XsWZiemDOH7CsWdV0uMj8xVcCG0rrpJG
	 De5Je7AAn/z/qmD0OiGerzh1TGdZzzgbwqkkr692zbJRro9BIVdiekG2I+YNz0RtLRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJcBUspZNK/Stbt2s9q4befB1ymtaIs1bt0t+/l6XH0=;
	b=FqKakfrrHfpXzZ0nNuGnzz5uORMc7tbTuO4PjCZHVG93PtUKDo5GkEI8nnLNQnqQbKd6
	 DLIFNrhHFyXDq2PftERaHDz8B06MCr0+0Ixl5kCd0JXbHIARwSVRYc6VwWvXP5SHt8I1J
	 B13xlxM44iBTOsl3rONxdmkfoF7I2Z9o3sYnWH+QO6O9XAY8ehgyTL1gr51peg+iES4Ip
	 gKI7kqGsHfsoxqE2EyqY9QLgHhVq70/lXj7r5cgb/M0drESwhYvKiagv9uV/bMMDApU5S
	 TH+B7o37VSNxnf4gWIWeGhKCNw6qVo9H2mrqOWLPsLrAeqvq/A0c5sFs47GHobZGhXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJ38j+mF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639DD606A325;
	Wed, 18 Nov 2026 23:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJ38j+mF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDB01F000C4;
	Wed, 18 Nov 2026 23:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042833;
	bh=uJcBUspZNK/Stbt2s9q4befB1ymtaIs1bt0t+/l6XH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJ38j+mF/5qecKUBfTJpO8svJ2VZVnBvWgmURLlcN42sy/3C5ZCIzm4o0wTX0+3Id
	 T1tHXvwCTQMf4Z01YoFMwiDsWqfbI8V3BbryHA5cxJo+2wYirLa6JTBmONwHdoJPy8
	 m2E3dsDPnwZGXgQyVuwQ0PdfG0kA5/N0Ww5jJzZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 3311/3318] cpufreq/amd-pstate-ut: Dont check for highest perf matching on prefcore
Date: Wed, 18 Nov 2026 16:05:33 +0100
Message-ID: <20261118150458.913028335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 9983a9cd4d429dc9ca01770083c4c1f366214b65 upstream.

If a system is using preferred cores the highest perf will be inconsistent
as it can change from system events.

Skip the checks for it.

Fixes: e571a5e2068e ("cpufreq: amd-pstate: Update amd-pstate preferred core ranking dynamically")
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate-ut.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -160,14 +160,17 @@ static void amd_pstate_ut_check_perf(u32
 			lowest_perf = AMD_CPPC_LOWEST_PERF(cap1);
 		}
 
-		if ((highest_perf != READ_ONCE(cpudata->highest_perf)) ||
-			(nominal_perf != READ_ONCE(cpudata->nominal_perf)) ||
+		if (highest_perf != READ_ONCE(cpudata->highest_perf) && !cpudata->hw_prefcore) {
+			pr_err("%s cpu%d highest=%d %d highest perf doesn't match\n",
+				__func__, cpu, highest_perf, cpudata->highest_perf);
+			goto skip_test;
+		}
+		if ((nominal_perf != READ_ONCE(cpudata->nominal_perf)) ||
 			(lowest_nonlinear_perf != READ_ONCE(cpudata->lowest_nonlinear_perf)) ||
 			(lowest_perf != READ_ONCE(cpudata->lowest_perf))) {
 			amd_pstate_ut_cases[index].result = AMD_PSTATE_UT_RESULT_FAIL;
-			pr_err("%s cpu%d highest=%d %d nominal=%d %d lowest_nonlinear=%d %d lowest=%d %d, they should be equal!\n",
-				__func__, cpu, highest_perf, cpudata->highest_perf,
-				nominal_perf, cpudata->nominal_perf,
+			pr_err("%s cpu%d nominal=%d %d lowest_nonlinear=%d %d lowest=%d %d, they should be equal!\n",
+				__func__, cpu, nominal_perf, cpudata->nominal_perf,
 				lowest_nonlinear_perf, cpudata->lowest_nonlinear_perf,
 				lowest_perf, cpudata->lowest_perf);
 			goto skip_test;


