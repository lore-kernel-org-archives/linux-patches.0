Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4841DE2A5;
	Tue,  8 Oct 2024 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391672; cv=none; b=t6y61ak8iRiuOXXwbwOvvR0NtXCeU/YLttyvdMrFElRZjxV0sV/JrzLrcbKjo+WdVgJpAIsPLwmqKRml5481uGZnwl+cfdorxAdFgRlI3PMjvQcRcuTe1iVLvkvLMA98g86/04rjPPY+bv290smfoy55JhfAImz+nSBL5lip2MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391672; c=relaxed/simple;
	bh=15+HR1J95+WhQA+1Tg2FaXec+gu/sOBh5CNHVU+3jZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6ZnK1DIS5k/H/6G2rFvAC7ICa1jZ3azL8vvxJq691RFRaPWKCKFQ0w1uDFtnnz3ty+/qYvOdbsVfTa0QfmQobtHf3FbV7Ty3w3FYauSXLDesrtUo9yBpQ1mzT1t6/cyKjsvGhYQpNObNYqsUi1ltBJddPLAg8Khbc+OdVZzjVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQoZ+FfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQoZ+FfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D611C4CEC7;
	Tue,  8 Oct 2024 12:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391672;
	bh=15+HR1J95+WhQA+1Tg2FaXec+gu/sOBh5CNHVU+3jZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQoZ+FfR9sS3puCQpdyKBLFsqHMaLOJw1yaH44PT1ue0o0gibRyyZA6Pi/UiXTdZi
	 X1W4MNgydrsOdobNf65h8k8ZIFjRRLMZmbTKeEpPAS/FbGNQwhEcA1hvr31xv7AMW5
	 k0mo7VyyzFTEpICqiq2OJV0ubKFxwE+oLcRmgqdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Pauk <pauk.denis@gmail.com>,
	Attila <attila@fulop.one>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 189/558] hwmon: (nct6775) add G15CF to ASUS WMI monitoring list
Date: Tue,  8 Oct 2024 14:03:39 +0200
Message-ID: <20241008115709.787480035@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 1f432e4cf1dd3ecfec5ed80051b4611632a0fd51 ]

Boards G15CF has got a nct6775 chip, but by default there's no use of it
because of resource conflict with WMI method.

Add the board to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Tested-by: Attila <attila@fulop.one>
Message-ID: <20240812152652.1303-1-pauk.denis@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 9aa4dcf4a6f33..096f1daa8f2bc 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1269,6 +1269,7 @@ static const char * const asus_msi_boards[] = {
 	"EX-B760M-V5 D4",
 	"EX-H510M-V3",
 	"EX-H610M-V3 D4",
+	"G15CF",
 	"PRIME A620M-A",
 	"PRIME B560-PLUS",
 	"PRIME B560-PLUS AC-HES",
-- 
2.43.0



