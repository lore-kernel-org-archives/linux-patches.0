Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A3E44C51B;
	Thu, 20 Aug 2026 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248102; cv=none; b=Lz1IxKWJYZWsNa4Sa1oz0Nf3Lg0K8X1+SU5B1YI+X34tTxFn9LrJT1J0yKT+cQvJSJryvOsyZfbVfJmVbsiIquSZLfBW/4n942fY0xK42/B3i4SuJak8Nf69EqLUZxOeHfNzdrmuyc1Aq3Iya/UJsASZNRFWeC/At+lZ+0Itnxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248102; c=relaxed/simple;
	bh=vYKxuvbOEovbyF6gI4XUDdYHFMJODmd/FhyyM5STNJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfeCu8L+AM6rMHzXQUT5G8L8XyXIKvDWrla7bSWJmFh3uMTF4GR9DhQprkw6NEcijNpa917T2vJI/fwF6gzQcr8/2FbWWWC/EeIudZ/pgEB4DWLd4CegRqqk+pNCsKJEMTC5KjXVFIUIaFsaUe5+xtuKnVD+Hvt04cm0fnYyoOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzdNd/Tp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzdNd/Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20791F000E9;
	Thu, 20 Aug 2026 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248101;
	bh=juwqXL7IHhbM2hFT5bqs7u3LfpoDXSM7Qx8HfK/xgPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzdNd/Tpi4YuEJW8Uf0E2RDw4HB1zvrwuCjKheZaoKfV69JfTOe3Odxced6Qc/a4B
	 DYMBhX/t53ryhDdcdne3lXqqK/e/x+qtOZgnkZBbLKgVmuONap44OyTPrxe7A9AX+Q
	 mMsl4x/NOvvvYygu47bY04g8iNNwkL3TXfTSgxjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/303] remoteproc: qcom: fix sparse warnings
Date: Thu, 20 Aug 2026 16:54:08 +0200
Message-ID: <20260820145256.648285140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit 2554dd0ac362738f588ba073d8333eb9b14f9587 ]

This patch try to address below sparse warnings.

drivers/remoteproc/qcom_common.c:126:27: warning: restricted __le32 degrades to integer
drivers/remoteproc/qcom_common.c:133:32: warning: cast to restricted __le32
drivers/remoteproc/qcom_common.c:133:32: warning: cast from restricted __le64

Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1675180866-16695-1-git-send-email-quic_mojha@quicinc.com
Stable-dep-of: ecf9fc18e62c ("remoteproc: qcom: Fix leak when custom dump_segments addition fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -123,14 +123,14 @@ static int qcom_add_minidump_segments(st
 
 	for (i = 0; i < seg_cnt; i++) {
 		memcpy_fromio(&region, ptr + i, sizeof(region));
-		if (region.valid == MD_REGION_VALID) {
+		if (le32_to_cpu(region.valid) == MD_REGION_VALID) {
 			name = kstrndup(region.name, MAX_REGION_NAME_LENGTH - 1, GFP_KERNEL);
 			if (!name) {
 				iounmap(ptr);
 				return -ENOMEM;
 			}
 			da = le64_to_cpu(region.address);
-			size = le32_to_cpu(region.size);
+			size = le64_to_cpu(region.size);
 			rproc_coredump_add_custom_segment(rproc, da, size, NULL, name);
 		}
 	}


