Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826B84878B;
	Sat,  3 Feb 2024 04:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933735; cv=none; b=N+mtbo9ZU7m2kyP5KhtRIQo8jJMdig3JD8GFY+xkZppoDG4isE9wpk31EwgcrtvUpo5XZFX8km7OGLjKRA/4pgbFVdMXgFFjxvp4h8q+nnrWVGOgi7ZvsbyVu99ycLc8YFG+8Vb8NJUFfzXlU175mQVzJtWyl2cnpK1iFFHwv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933735; c=relaxed/simple;
	bh=pdwLUW89UrCMjKsHCt5ohqetwq1yAF8g5av+7allScE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbMvmRf6Txr1f9i/z9ws+e/By4lD9Xlo82rQHQJHoTs5a0U1RDfJw3MR4cTki5fgJPCZ6AK0QF4Qr+KZVt1boo65b4Hey4EQMemORaCJGLcAIcRyii+7IWDJR3er+700X+q6F8nxD9OpeC1uZ8pCo1EfiOaSNEF/feEpalllQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yd6V5Cs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yd6V5Cs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFE4C433C7;
	Sat,  3 Feb 2024 04:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933735;
	bh=pdwLUW89UrCMjKsHCt5ohqetwq1yAF8g5av+7allScE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yd6V5Cs1HbROaisTPGQaF/4HYw7ZBAVlyqTYaRVV2bsms6Fg1rWVFGgwf9uas0ChD
	 eF7HUZBVllm1qZobUSjDevUJgKXRAxP7IEz2oxXbZ+b4NgVtPApdyNbzmfCAa3mnMv
	 J298HP0vo0B2J3fvSrgQL16ccp8P++n3CzUEuWr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 023/353] ACPI: NUMA: Fix the logic of getting the fake_pxm value
Date: Fri,  2 Feb 2024 20:02:21 -0800
Message-ID: <20240203035404.488840785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit e3f577830ce216b0ca21d4750cbbd64cfc21efff ]

The for loop does not iterate over the last element of the node_to_pxm_map
array. This could lead to a conflict between the final fake_pxm value and
the existing pxm values. That is, the final fake_pxm value can not be
guaranteed to be an unused pxm value.

While at it, fix up white space in slit_valid().

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/srat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 12f330b0eac0..b57de78fbf14 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -183,7 +183,7 @@ static int __init slit_valid(struct acpi_table_slit *slit)
 	int i, j;
 	int d = slit->locality_count;
 	for (i = 0; i < d; i++) {
-		for (j = 0; j < d; j++)  {
+		for (j = 0; j < d; j++) {
 			u8 val = slit->entry[d*i + j];
 			if (i == j) {
 				if (val != LOCAL_DISTANCE)
@@ -532,7 +532,7 @@ int __init acpi_numa_init(void)
 	 */
 
 	/* fake_pxm is the next unused PXM value after SRAT parsing */
-	for (i = 0, fake_pxm = -1; i < MAX_NUMNODES - 1; i++) {
+	for (i = 0, fake_pxm = -1; i < MAX_NUMNODES; i++) {
 		if (node_to_pxm_map[i] > fake_pxm)
 			fake_pxm = node_to_pxm_map[i];
 	}
-- 
2.43.0



