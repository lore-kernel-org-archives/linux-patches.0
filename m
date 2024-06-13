Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC51148853;
	Thu, 13 Jun 2024 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279823; cv=none; b=aglMINAvSvE/UCdolOlEJ8aT6anH/PtLNf/fxbnO2/o0wJdsoRr9FWKzBj8sxtujqsfYMC0zWCZ4BxruUt1DSSxgkr5cfyyZDa6PNHSXpYjFUfplUWDVLCnmF0cqsf/4rCWKhvv3GUMseHbUxMPvwv2PBBrI+66KYa4N4G8lleo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279823; c=relaxed/simple;
	bh=vbte0pYZxiXmsxuKsABioAV/ZIw0sbNz3H4C5+Aq+8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKKVDTOMzD1WoG5FBu+ekbV7Ra1VNOxdUC7MivoHEeoT4mVICIny2uV51IHlSqtlw7CZ1084zgchu705TSw7bZG1ggPQEU/y3UUgoAv7BvTBvFGBW/H+iTRsuZiHx53OwgbZt/m47VP4xW3y3pmvjATp1AzfC9R00APecQ5aWXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzFS5DcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzFS5DcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FACC2BBFC;
	Thu, 13 Jun 2024 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279823;
	bh=vbte0pYZxiXmsxuKsABioAV/ZIw0sbNz3H4C5+Aq+8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzFS5DcGx+w4RU1s8T8HPjl2eSmXHjX6MfIgaMpheg5BS4MKylXOhA/e6Ydo4TMAf
	 BbIgH7vPG8CaejD+mrY71BwSvN3ORHRkeriqjxgUrL4EXMA1awsVp5LBaJojgdMzLY
	 gK/+c3KS99JHPgQQ9L1pY8Ff8s68WlNd6UyyfbEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/202] parisc: add missing export of __cmpxchg_u8()
Date: Thu, 13 Jun 2024 13:31:59 +0200
Message-ID: <20240613113228.586445863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit c57e5dccb06decf3cb6c272ab138c033727149b5 ]

__cmpxchg_u8() had been added (initially) for the sake of
drivers/phy/ti/phy-tusb1210.c; the thing is, that drivers is
modular, so we need an export

Fixes: b344d6a83d01 "parisc: add support for cmpxchg on u8 pointers"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/parisc_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index e8a6a751dfd8e..07418f11a964f 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -21,6 +21,7 @@ EXPORT_SYMBOL(memset);
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
+EXPORT_SYMBOL(__cmpxchg_u8);
 EXPORT_SYMBOL(__cmpxchg_u32);
 EXPORT_SYMBOL(__cmpxchg_u64);
 #ifdef CONFIG_SMP
-- 
2.43.0



