Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61132320CC6;
	Mon, 18 Aug 2025 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522510; cv=none; b=bQbQGAb7nYzlHJ6cInm7rlk2afdqRGaj8LFsDhVvv7tnxfigpWSviILH0qjWKKb+kH+2VJ56SSMtQLbdIUHIS2tceFWAISOUjdGDwMRt4kk8NsLfOM/G2We16NrakKLHAnlOSw8g7xXl16t7NNH7jin/IiV8hai37olI5Shb6z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522510; c=relaxed/simple;
	bh=bHK2mArjQs6WMOPqJLlD4gm7bUlzBozP6IGCXbVmTJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkIiMV04AGDioLRPaxHXBiQmAgUpxvgwSQcriUDQ/+fZfOvTezzdcIBNf6wolDZaBv+GZlRnItll6wQPN25EA/83eqDnwAA+UE9zWIaFDLRFcbZ4fEVXHLk26p00dsV4GzI8nOhLfAMYKpOww0tA7uX4cfx6XzqXXc3KgJxiIOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLNW0YYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLNW0YYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5398C4CEEB;
	Mon, 18 Aug 2025 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522510;
	bh=bHK2mArjQs6WMOPqJLlD4gm7bUlzBozP6IGCXbVmTJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLNW0YYhsQ5D2S45x57EmjknJ2iqd9W4hSbFC5p2veYl7OSVk6t7fXBbjRHA7l5Rq
	 Pt6OTbyOc4ifpu6/fWZ9wPy/6q6NIYC4LKzEv431djdIiPRPQwt/1AdAeNDQ7n0rkK
	 aHRqJ1A4ZMgMk4ZAzdS0jy56AjV/x9T7Uu/q1gjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"fangzhong.zhou" <myth5@myth5.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/444] i2c: Force DLL0945 touchpad i2c freq to 100khz
Date: Mon, 18 Aug 2025 14:46:04 +0200
Message-ID: <20250818124501.605411088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: fangzhong.zhou <myth5@myth5.com>

[ Upstream commit 0b7c9528facdb5a73ad78fea86d2e95a6c48dbc4 ]

This patch fixes an issue where the touchpad cursor movement becomes
slow on the Dell Precision 5560. Force the touchpad freq to 100khz
as a workaround.

Tested on Dell Precision 5560 with 6.14 to 6.14.6. Cursor movement
is now smooth and responsive.

Signed-off-by: fangzhong.zhou <myth5@myth5.com>
[wsa: kept sorting and removed unnecessary parts from commit msg]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index d2499f302b50..f43067f6797e 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -370,6 +370,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 * the device works without issues on Windows at what is expected to be
 	 * a 400KHz frequency. The root cause of the issue is not known.
 	 */
+	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
 	{}
 };
-- 
2.39.5



