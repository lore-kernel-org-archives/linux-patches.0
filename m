Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907DE266580;
	Tue,  8 Apr 2025 12:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115018; cv=none; b=L6dGfWMkQektDVyGloqPEwrnwUcdFeE3Qfj6Nsgo874qytjaesD5WIMNB5HvVNWf2C4x2AXYSYIdfFxONWeUb/5AbahR+JLyrDRRu584O7mQXXTfm0CuKsalUGZ/41t5Nte9B+XELmG2X2ydJ9mUHwkuNxqQS6AdO91cHazCkZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115018; c=relaxed/simple;
	bh=iyYh4uaaKn/MFw1R8EPNBez/zYOpiB+fWYLu4mSY6vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrJ9UmsfbHMDc+EN2wOBLFBQCR5qrJnCNyFVcD9Cn365Khuw5MSkH2F2AvK/Tq5LWs2saeUQlCUPOvxwpDxBuqKMCdne/h/Vdad3SUtOb36J4mRuivd/S9n6Cnep5JGCfLl5dw5CnpcwhuUB7tGiwH/GiRy50p6VT2Vy41lVERo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drZwME/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drZwME/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F447C4CEE5;
	Tue,  8 Apr 2025 12:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115018;
	bh=iyYh4uaaKn/MFw1R8EPNBez/zYOpiB+fWYLu4mSY6vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drZwME/M0f2skGGryHYXlvOgOLmdtS3ytElFzfhOqcM8+7MdLlo7n5YgUMfTy4W5B
	 qW0Z4f99ZQIEh0hOiDCeKVYFgBaC1j/89UlPF+c9xtb+9jNSCtUwr5HH1rb7emraTd
	 2eHWbS1wGkgwpDGlHycFMRHYGJFwfmyBZIHmeTWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 319/499] HID: i2c-hid: improve i2c_hid_get_report error message
Date: Tue,  8 Apr 2025 12:48:51 +0200
Message-ID: <20250408104859.179943343@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 4e87380d3edd6..bcca89ef73606 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -284,7 +284,7 @@ static int i2c_hid_get_report(struct i2c_hid *ihid,
 			     ihid->rawbuf, recv_len + sizeof(__le16));
 	if (error) {
 		dev_err(&ihid->client->dev,
-			"failed to set a report to device: %d\n", error);
+			"failed to get a report from device: %d\n", error);
 		return error;
 	}
 
-- 
2.39.5



