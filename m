Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E98197551;
	Thu,  6 Jun 2024 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682986; cv=none; b=c629oWan6Q2EWciSpgzxHNNnJdJ3YbGqv2WtdDI2fCXXOrgjkqzzEBDNsUFHpi3eNODpmLFKZS4kLh4Sux6rAS/NSE3zmA24evZRGTsMLP9z7X8l/w0w5wxxForCtbvz2pi5uROI/tSpI696bIZBy02eIqQTNxiNVlQVWTzGUFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682986; c=relaxed/simple;
	bh=yiwomz5EhsMbqUps8CWITtFtkDBabRaeoKZ5XExezMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAhipltcOuZ/cDbRl0LsOXEbnDq+8ROY9iyc93yIaxXxbBgU53pILe4HWXT/IipdLismII3rKw27gFQ+1i5CTioSkSi4waTG26gY8x5mkIKTBGN3bGYHBjrlG6sv7RVYKvXZXsExEWdSQtkMjhzsnWWblaJyQwI2OiRVihQcq/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znPxQ0eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znPxQ0eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC66C32782;
	Thu,  6 Jun 2024 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682985;
	bh=yiwomz5EhsMbqUps8CWITtFtkDBabRaeoKZ5XExezMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znPxQ0eoxZQhUD6mlFCjSPns/wXQeQaMhQZeWEBo0E/o6MLhslJSeqO3UhbMVPjH3
	 5L53MKJDLfKGao/VR9H2qd3E4lcfFkinliT0cAkz5T9AkiGxdw65q28LL8MZS+1J/y
	 GGUhSiu8LoxsTR52+oO2QsT+nfjjniMcoL/iX1Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 172/374] fs/ntfs3: Use variable length array instead of fixed size
Date: Thu,  6 Jun 2024 16:02:31 +0200
Message-ID: <20240606131657.659030272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1997cdc3e727526aa5d84b32f7cbb3f56459b7ef ]

Should fix smatch warning:
	ntfs_set_label() error: __builtin_memcpy() 'uni->name' too small (20 vs 256)

Fixes: 4534a70b7056f ("fs/ntfs3: Add headers and misc files")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202401091421.3RJ24Mn3-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 9c7478150a035..3d6143c7abc03 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -59,7 +59,7 @@ struct GUID {
 struct cpu_str {
 	u8 len;
 	u8 unused;
-	u16 name[10];
+	u16 name[];
 };
 
 struct le_str {
-- 
2.43.0



