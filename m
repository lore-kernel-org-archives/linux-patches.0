Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4528FBF2;
	Sat,  3 Feb 2024 04:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933509; cv=none; b=Q5QVdiEo5WVGzorEoIv6UjJX3yAriezOGMcbWztIudIIIbcM8kltRzNdf2ExBJSNml0Yu5W3il5QKUyRLKF1tm4tWWZ139VBqo4Isk96Y9Irkycl/9lbAohCdk8aRFbpFuotLrqL/kkW09mbW0HndYPwCdrVBeOooULiXq7JCO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933509; c=relaxed/simple;
	bh=PAsaa+5KztzH0P8uW6547nKEUhKP0hG8OQamR9LOEKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm6uGCLmCpiKrIqBP7GzyPqz+Y1cOabRXp0Bg05GMT416bBcy3HF5l21LKhycX/KUkOUQrgR70JTwgiRirhgE3foBU6eibQvcBerKf8E02w6QFwc5gN02ZaLguNhmuQvtGp34gMgKzVq4WZ+Sk9POMzmwZdx5RJxxGfBdsURDi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWmaXpFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWmaXpFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D42C43394;
	Sat,  3 Feb 2024 04:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933509;
	bh=PAsaa+5KztzH0P8uW6547nKEUhKP0hG8OQamR9LOEKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWmaXpFeITNzqru+ZO0bvgTs0lZWb9NgKz/u13wNE5PMSkuBp0X5uOvrdC/jOEbIA
	 eh2rtq99/ujFMiWLX4+5jy1YkCHugyfWn6oyhyiKTmio6sfE3bBZPJb0Xz+dtGgneT
	 BxP/wjQuNLOCU/BSj1fWpIdK1RMyCylJhHJnRkAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/322] ACPI: NUMA: Fix the logic of getting the fake_pxm value
Date: Fri,  2 Feb 2024 20:01:58 -0800
Message-ID: <20240203035359.732622339@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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



