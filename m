Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7405937757A;
	Sat, 12 Sep 2026 07:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199325; cv=none; b=HYgK3j0/AtUE3n1A/12/cyzmJsH0H/JY2CcTMf9MCgC1kG2N+RfZisWlLloDlvK1cdQWanHpTW/hB2KpoKVt7WQgbsL5VlfGkTo/6Zqn+jh8sRooz/AFZHvJBBAhQSdtk1Bm++yCEaqDictYbjmFwdy0CqF4XFka8Dj0cvJyMrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199325; c=relaxed/simple;
	bh=0R62bsIc6ltSzS64Qz1ZWMTJ166/oQ1Ee+sbC58Hd84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lv18Ju53rwc9mMVXmvgV092sL61rffpVPd/xCfrSmbk21mEMYcVvO+OMP25oFHckexeBwcy4+YT/cZAuTcNtH/o1CDUjQ+Y4LX6z86kaDlNmAFTsw0bm7mTe0K9xK1nwOmEW+K7lWc/2kg1kt5/gqJaKdiPxiB9CcpnVrFTdGEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcaJi5Cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcaJi5Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4381F000FF;
	Sat, 12 Sep 2026 07:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199323;
	bh=Am4wOVte86t7jgQUdFZka149BMx6A93TIMOrOBxjpBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcaJi5CdBYL4sAeg/l1Qx6TEawICIlbTj8lNIjyXI/tszryLihX46f9Jis2XJrZNy
	 vuLBTomS6yojdq0nja0qzJVW/IGWoANxN7gnxwAbFmIQ4a1+S4e2eHr+59hiq6jXNl
	 SEmx2vxdwQSalm3Ukvl+zywC0TOBl/u2cg5kkszk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0562/1815] platform/x86: acer-wmi: reject missing gaming WMI results
Date: Sat, 12 Sep 2026 08:38:32 +0200
Message-ID: <20260912065702.076592516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e0eaaefb13d04..61ae622c93d94 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1581,7 +1581,9 @@ static int WMI_gaming_execute_u32_u64(u32 method_id, u32 in, u64 *out)
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



