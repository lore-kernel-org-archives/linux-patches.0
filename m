Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F02186E51;
	Mon, 12 Aug 2024 16:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479244; cv=none; b=lr/MmCYIIm/jhpA/RVeZV6E+8bKhy86fHBzs90Ds0HNd/Mwqlw20zeI2c00yQqPI/w1HQ7rVk6czjZGl8X4rJIUmPvsra6b34poIVjKb8eZkaBiPvYToOa0AQLbvKdUyG/id1TTc8EAsjUo4NBLy3W1zEtiYiygZEB3dDoAcM2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479244; c=relaxed/simple;
	bh=bs+sz4i0itXb99LpcEmvxYKI0x3CO4A5p8B7UYSUVkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TqfRuDA3l0HuPYCtszY8j4L7d1/l7RfqBWyhvOTuhyKu07sARymIQzQWZJbWT4bplVqCAipwOa9phJPNauSzEoHm7twhYt4clM1rl4uzoUPTzXvS+2C0ft4h96g7lrrZqIr+qW2GM1kUlEY1LHo7pGAFROmvQYYOATxTcR0qHow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z91Q3Yfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z91Q3Yfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A69C32782;
	Mon, 12 Aug 2024 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479244;
	bh=bs+sz4i0itXb99LpcEmvxYKI0x3CO4A5p8B7UYSUVkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z91Q3Yfv5qP1ISPNT17+WwgkpUTU1BwyKYrFrX42lX7zul80D99OegVDtKzlFS2Ow
	 dCH1yVk3YAnbg7VwJka1PJVtG2aTI0MB85TbH6dPP2kAJinRTjCQS/Ym5zzxvkZwPI
	 bjIun3SG1/sPHAeu6hl1gx9qXeZX6jlMOS37oOMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/189] platform/x86/intel/ifs: Initialize union ifs_status to zero
Date: Mon, 12 Aug 2024 18:01:00 +0200
Message-ID: <20240812160132.308904015@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 3114f77e9453daa292ec0906f313a715c69b5943 ]

If the IFS scan test exits prematurely due to a timeout before
completing a single run, the union ifs_status remains uninitialized,
leading to incorrect test status reporting. To prevent this, always
initialize the union ifs_status to zero.

Fixes: 2b40e654b73a ("platform/x86/intel/ifs: Add scan test support")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/20240730155930.1754744-1-sathyanarayanan.kuppuswamy@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/ifs/runtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index fd6a9e3799a3f..c7a5bf24bef35 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -167,8 +167,8 @@ static int doscan(void *data)
  */
 static void ifs_test_core(int cpu, struct device *dev)
 {
+	union ifs_status status = {};
 	union ifs_scan activate;
-	union ifs_status status;
 	unsigned long timeout;
 	struct ifs_data *ifsd;
 	int to_start, to_stop;
-- 
2.43.0



