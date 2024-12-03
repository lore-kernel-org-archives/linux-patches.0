Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA641E3DF9;
	Tue,  3 Dec 2024 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238129; cv=none; b=ewUligtchBWLD1VFvfR5DOSlr8aSvsXkU/6zFiO8+oqVFi/akdpxP41NDycu44nPerZFfVcgq8V3UsOkgCbmXETZtvPLpbifNYd1HgpZufG6qrm8dzPSvrPBnpK8uxY93KrB0oJ9lWVdB4wLGfog7oQpVjGm6nLSTMT9M7lg6gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238129; c=relaxed/simple;
	bh=yZInF49Hx/0QmFyGUbZCSxC9Y/1/c43iJQYXxEY7IuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5sGi0GLg8JoRWUOF273VERNPK1BkICFWdGZcLs9ya0xXg2naY7iZ8hnuof3sSUvFRruwwv2/fN3ZYfTOatvRCJDBe/F8omnf/VpsBA0kKNjABN0AcKM5Tt+J5popvFQbEzKVEjqCWrr7ZcHWexZMLlP5LYHkfQa3o0trM5cMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC7C2gSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC7C2gSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8732EC4CECF;
	Tue,  3 Dec 2024 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238128;
	bh=yZInF49Hx/0QmFyGUbZCSxC9Y/1/c43iJQYXxEY7IuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC7C2gSBrg7BxwrQBqBkav1oMDjPDY08/RIijnV7n7l2rZEIIkUvYEqxOk93xYpl9
	 MvM5OXIOnrIT+VyDNRRBYsOChO7vVJRY+ECjNMIM+OX0JIimGCosngOU54b/GtiofV
	 3MXUGqV/nOzUYluSQj7rrQpOpfRTwZ8KkRd9F4Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 140/817] regulator: qcom-smd: make smd_vreg_rpm static
Date: Tue,  3 Dec 2024 15:35:12 +0100
Message-ID: <20241203144001.187897750@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 18be43aca2c0ec475037923a8086d0a29fcc9d16 ]

Since smd_vreg_rpm is used only in
drivers/regulator/qcom_smd-regulator.c, make it static and fix the
following sparse warning:

drivers/regulator/qcom_smd-regulator.c:14:21: sparse: warning:
symbol 'smd_vreg_rpm' was not declared. Should it be static?

No functional changes intended.

Fixes: 5df3b41bd6b5 ("regulator: qcom_smd: Keep one rpm handle for all vregs")
Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240926231038.31916-1-minhuadotchen@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_smd-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom_smd-regulator.c b/drivers/regulator/qcom_smd-regulator.c
index 3b7e06b9f5ce9..678428ab42215 100644
--- a/drivers/regulator/qcom_smd-regulator.c
+++ b/drivers/regulator/qcom_smd-regulator.c
@@ -11,7 +11,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/soc/qcom/smd-rpm.h>
 
-struct qcom_smd_rpm *smd_vreg_rpm;
+static struct qcom_smd_rpm *smd_vreg_rpm;
 
 struct qcom_rpm_reg {
 	struct device *dev;
-- 
2.43.0



