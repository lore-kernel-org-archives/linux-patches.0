Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040777;
	b=r5wo80NtWTpwhTt84r9jBUZQlVpf3aLLa9Nzgjh5zqdp6//w/OvtoC1xMuLZwQsf54pB
	 JD/D3MS+QLbwaTUREM/XB5gBpgnHVq8QNbVaqxvqCekZTD2S06Z8JBleYw1c7q5K0Mz3V
	 HuzS4VwgeM1vaeYGJvNFWX9T3BV1PVnydFmMvtKPqh6QVnuhucxue9SZHTRmAp6TGn4ab
	 1TlDk52oAy2G5zbXX5aV3tSd9vtc6mD80dmQ43BZHlljB7kR+SCM9ciyUG1N0gsHvltDB
	 cqGFibORBJax4ytJhZonS9vhdgW0S3tCDBmtSn1v/hCSnwV92R3SLHU4iNWMMiDtY8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjXZ8fc1mQ6qKEAqF+P6g7Jxf/xaA6R0BmOGatBsg64=;
	b=Kp5L05zrHpWJXwlEEHEX073EMF6T1t7z91kjp7eQxFZC/gyVTGzmK+9dyDMjD6ug0nJn
	 o8qUoVWstI+O47X8GZScHDEJ2pDYy6gK7+TTUOzRjmu1piVWRAUuQYDWSED/lR6oA9BbH
	 xWTH3ZjrKIn2nvBlH5GuAUTYsZ1S8zx8qEXGlFy3U/erhFzXRw16n0x3QGzXs5MKo6muB
	 oz8YZzyGbvAM21aUa4hUk993NhcUb3ywUUlI6KGWzQsyOHjP4xdsS1I+O7Q1TbPybscGl
	 NNGs/egRN3GK4iV3q9VuKd1HiwoT1aY0UcPow+yR5L+yw0mN54UfxpSxuwdmWCE823Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRwM3zJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992E8606A325;
	Wed, 18 Nov 2026 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRwM3zJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1B61F000C4;
	Wed, 18 Nov 2026 22:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040777;
	bh=pjXZ8fc1mQ6qKEAqF+P6g7Jxf/xaA6R0BmOGatBsg64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRwM3zJDGh/83MDdkfTEx2A587lRLH6mUEt7tSwpnCN8Agwv3iemXnSy/r2JXmyix
	 kZH6x5fecFqSVv9MvyqhMBICnuM2cxQMdAXP4B9K900L8fXu2aWZ/zD+nzxDScvpVE
	 +e3e6NDNJh4gDTwuQVj3zBvwyfz6hvleCTyIBFWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2541/3318] perf/cxl: Program the requested event group on configurable counters
Date: Wed, 18 Nov 2026 15:52:43 +0100
Message-ID: <20261118150437.539307881@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit b22dcc11429866e07dc54299255e8ca13c26d38a ]

cxl_pmu_get_event_idx() sets *counter_idx for a configurable counter but
never *event_idx. hwc->event_base stays 0, so cxl_pmu_event_start()
programs event group 0 no matter which group the user asked for.

Return the matched capability's event_idx.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 2455af65ae271..fdcbf50cc2a3e 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -521,7 +521,10 @@ static const struct attribute_group *cxl_pmu_attr_groups[] = {
 	NULL
 };
 
-/* If counter_idx == NULL, don't try to allocate a counter. */
+/*
+ * If counter_idx == NULL, don't try to allocate a counter. Callers that
+ * allocate pass both counter_idx and event_idx.
+ */
 static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 				 int *event_idx)
 {
@@ -549,7 +552,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 
 	pmu_ev = cxl_pmu_find_config_counter_ev_cap(info, vid, gid, mask);
 	if (!IS_ERR(pmu_ev)) {
-		if (!counter_idx)
+		if (!counter_idx || !event_idx)
 			return 0;
 
 		bitmap_andnot(configurable_and_free, info->conf_counter_bm,
@@ -560,6 +563,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 			return -EINVAL;
 
 		*counter_idx = i;
+		*event_idx = pmu_ev->event_idx;
 		return 0;
 	}
 
-- 
2.53.0



