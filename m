Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89290224234;
	Tue,  8 Apr 2025 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113484; cv=none; b=ohkJJNC1rhCR/pA7KYSbC8pz5Ttw3uI3vy33tnwEIOjjrM3qV2KYFbz9jIH/iHIKOAg+vXGDq0zvTZsRq0WfT8mZtLW2dEJTSSU4CzyNeF5V5qkmUUq/poVjqptfDKYGb8pTACk+z/VVQDW8u+mKh/3syyWp4RGmGTPmMq3l3UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113484; c=relaxed/simple;
	bh=8dXNQZr4F1EkAwuGXokH+1JGJPE7uDGVcepTqdkuEOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2nmkPjCWWEbSKLSmdg+AYEN/+Ho1NCzLLT7MbWPPFl1T4OlCpGlIpZyk/Lz6o7T1IP11qsD2Tj1gEljhTocV3ggonmOcyl7trIn4eGG4/xwbXcCNjrULjWfZuA4KBUWTxIsa9fI7ps+EFjU+pPIPtYvn5rnQ8x9eoScJ4o2qdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6PCBB1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6PCBB1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CA9C4CEE5;
	Tue,  8 Apr 2025 11:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113484;
	bh=8dXNQZr4F1EkAwuGXokH+1JGJPE7uDGVcepTqdkuEOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6PCBB1VduEd9icrEfBAkbztmg6GTsk/gj6WWwa+yIirF5Oz1YQpUBeM6NL5dce1t
	 7t2abwg5lr+FlT1VvTeiIdlvti6Mn1fi01gQZ1cM55IIWfq+jS9Ww8Mk3DLEsAh5zr
	 mnXESuatyyXl1B0V6dX36cvXiI4Pe8kLyVgyT/kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/268] HID: i2c-hid: improve i2c_hid_get_report error message
Date: Tue,  8 Apr 2025 12:49:47 +0200
Message-ID: <20250408104833.291422893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 723aa55c08c9d1e0734e39a815fd41272eac8269 ]

We have two places to print "failed to set a report to ...",
use "get a report from" instead of "set a report to", it makes
people who knows less about the module to know where the error
happened.

Before:
i2c_hid_acpi i2c-FTSC1000:00: failed to set a report to device: -11

After:
i2c_hid_acpi i2c-FTSC1000:00: failed to get a report from device: -11

Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 045db6f0fb4c4..3dcdd3368b463 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -258,7 +258,7 @@ static int i2c_hid_get_report(struct i2c_hid *ihid,
 			     ihid->rawbuf, recv_len + sizeof(__le16));
 	if (error) {
 		dev_err(&ihid->client->dev,
-			"failed to set a report to device: %d\n", error);
+			"failed to get a report from device: %d\n", error);
 		return error;
 	}
 
-- 
2.39.5



