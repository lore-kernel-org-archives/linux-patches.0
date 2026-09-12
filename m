Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1059A3ACA6F;
	Sat, 12 Sep 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207855; cv=none; b=W4OK2kymmnsjehVRHmXZYM0+YjeStvcXJAlZuXCCuhrOK1Gm+N03M2J5nDZqacpPMlIXZU4XYEqr18XNIM/RiO5Ky75crEFqNLVUDj9CFZ2w7Y3vNkXUilIsBOaNLvzb1pnHefImoFqn5LNiqtZxnZxRA//+pc1CcP8cIF9j9UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207855; c=relaxed/simple;
	bh=ae8BUyf2A8YwZY/QfDLw5YeYU6MTgJGr6CcGbcTF0Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRZF9df5j4k42v9ZFQxa7SCXkk/aLvUkeJ7sqt6ESwSVVaEJhHMkQS7f1rYLDA5y7xrKjJWBXiODEuvu/R2OZffeN1xLDsTPnbtlFTxWBaz5QLIj4EdozUWnZsj8qeF7klVv9c8rMeHqwgJCPsw1hAIWYZMq+GopA11k/mmj4gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7zt9KKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7zt9KKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D981F000FF;
	Sat, 12 Sep 2026 10:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207854;
	bh=6jTL5x+E5GNxpa0mDBbYo/YNojo+GNM8GsfdAug0F5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7zt9KKgeeU37Fmkbl9ghWcj6h+WN1ghqihF4/K8gnagNccSZhDcdi+7iygdUDkvG
	 hrYo+bz9/drjB1JT/t7lYF9dlWl/9B2e3/XqZ1BAlPZLeq3lOSwtf/yjPTs4B3p39v
	 u+Z+xs/H0iiQ56XhvOPfEo361ghIarapPAYvpYrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0497/1518] platform/x86: acer-wmi: reject missing gaming WMI results
Date: Sat, 12 Sep 2026 08:44:26 +0200
Message-ID: <20260912065634.689148725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit caf8342512c3056005f475d350eeca089c3c6623 ]

WMI_gaming_execute_u32_u64() returns success when firmware supplies
no output object, leaving the caller output untouched. Gaming getters
then inspect an uninitialized result value.

When the caller requests an output value, return -ENOMSG if firmware
supplies no object. Preserve a NULL output pointer as the supported way
for callers to ignore the result.

Fixes: 2d76708c2221 ("platform/x86: acer-wmi: use WMI calls for platform profile handling")
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260701164208.8998-1-alhouseenyousef@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index d848afc91f87d..55b1980313542 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1530,7 +1530,9 @@ static int WMI_gaming_execute_u32_u64(u32 method_id, u32 in, u64 *out)
 		return -EIO;
 
 	obj = result.pointer;
-	if (obj && out) {
+	if (!obj && out) {
+		ret = -ENOMSG;
+	} else if (obj && out) {
 		switch (obj->type) {
 		case ACPI_TYPE_INTEGER:
 			*out = obj->integer.value;
-- 
2.53.0



