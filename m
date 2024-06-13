Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF6720ED;
	Thu, 13 Jun 2024 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282386; cv=none; b=lesFSI1HpshFs3iAkp3grQ/3n5luDS0he+YLkSptWdQalwi2zo6aCreyITg3flgXkNhJvFjuJb1zjuXTjhgntnD5vPlj+hI2aOvL6qBvvmQquNOVGPd692FfCiJq9+C4l7vJoYh0YAK8KNOxVXcnaaVBZuMTIcsUL0ZmKtN52u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282386; c=relaxed/simple;
	bh=JqmsDJGMo5tdSNiBUyjlJb+mNdglepa5LpEYXuI/YHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUxLhG/jsWJdNWAZyCiYhjqNVHnif3Dv/oZk0rFkGKlkT6JTIAuw/GzkNisyrz6DMTEzmdS28RdJHy2WjcClxBP7m05zt9pKb8Fe4d9t0SmyiBOPI9lIr+uCqMNWfdEyuIgQ0MRmSrh6joQK+b3Qf+KlCShX697GrEyovIkaTbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQyVrkzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQyVrkzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321AAC2BBFC;
	Thu, 13 Jun 2024 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282386;
	bh=JqmsDJGMo5tdSNiBUyjlJb+mNdglepa5LpEYXuI/YHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQyVrkzWzc/z8AqzZPdBoxumlGGDKtkaHFPaZFARZQ1g5BW9jzclLN58fZSguHT5C
	 y8KBh1Dt/J9W4+GDuYscFc1A7P0t6cIrJSoUuABwpusPGg/YDnfxnMt8Y5H3TQPn//
	 G5wh1f0kDIjIyu0zaHvB0kLUXGyYUFEPsZ5ETEg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/402] um: vector: fix bpfflash parameter evaluation
Date: Thu, 13 Jun 2024 13:33:37 +0200
Message-ID: <20240613113312.289348959@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 584ed2f76ff5fe360d87a04d17b6520c7999e06b ]

With W=1 the build complains about a pointer compared to
zero, clearly the result should've been compared.

Fixes: 9807019a62dc ("um: Loadable BPF "Firmware" for vector drivers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 45a4bcd27a39b..310fb14a85f77 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -141,7 +141,7 @@ static bool get_bpf_flash(struct arglist *def)
 
 	if (allow != NULL) {
 		if (kstrtoul(allow, 10, &result) == 0)
-			return (allow > 0);
+			return result > 0;
 	}
 	return false;
 }
-- 
2.43.0



