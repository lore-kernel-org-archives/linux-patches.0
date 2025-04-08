Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4923026B94B;
	Tue,  8 Apr 2025 12:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116795; cv=none; b=dNvppREjBkdMps9GqkUk2KqxdNDh0At9EyPivgviA1WaXhf6EnAatfL7sq4rLhAzGhQW9lYubkMSBNbvtnBqoJi5prP0TSPzSptqa+lhraF+7X1i9DbOG8wMMstqNwnAzm6s5WLBNxdeV4nr+rDXet8xtFX+zPJMjQVYq2c6RE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116795; c=relaxed/simple;
	bh=sMN7Zn9etem4umSLGRMb0vle2ZhZL7GQCevm4tSNZyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKZX5yybTr9SKGiMcVwmJGS2wEqMo09pxVFdl/ttto8FbNwbg5bjzy1aIMIIqR2jnREakED/kvvUqUFx/caBbGETcsPhj2H3I97hATlpxWQ3X6hWith3u8lbC+6An3b3qUgeRrZawKV8LNzeywTrTwnXuolF/NSEDsZ3w08zMxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHZojSkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHZojSkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7C2C4CEE5;
	Tue,  8 Apr 2025 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116795;
	bh=sMN7Zn9etem4umSLGRMb0vle2ZhZL7GQCevm4tSNZyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHZojSkGm6xi9u+/MO6nZg2EgxS612zU6BoI+/jdrEfCoZYHDhDYjbSXZsVxqMCWo
	 2rJw+406p6tZQP+BBX8qnfip5N4lrRe+XyJhnAIU/kNyqY6q+1CY1mp4sI/45TfVLT
	 Bi5NEz9vhwsFoDDdujdp2POW1g/NB22EcO0gX+Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/423] HID: i2c-hid: improve i2c_hid_get_report error message
Date: Tue,  8 Apr 2025 12:49:58 +0200
Message-ID: <20250408104852.093963973@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



