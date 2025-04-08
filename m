Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCCA21B185;
	Tue,  8 Apr 2025 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113737; cv=none; b=gNgmUXmNsUIMjalqpnEYC7jI3E8gQuYzMhlPwa6a9NB1otG4qI7ZsMSRyOoSlKrrv0NvgbjuBqtJ6ZylBFFRZUVg8ZJQztbQGV5aqAY82mubYguDPivvir6UZ1y7XlmwFDI1G5mz2JYxWTld/bfXc57LCRZBGKhESt3GYrkA+pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113737; c=relaxed/simple;
	bh=8j9rOk/5GJd/84Ab+wN55GP3c/1xS2su2ObUZSiOqdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XPGr27xAeCr62J0js/35GmEpIb9ZqcY21ezd1rSbEYciAZnUQ8TY1kQEr/wY9xxCchrXQYgZUyAKwXtLkJjBAss48C0XGY7ybbs7kJmHwqV1vSr7d4yo7FYX/3UnAm+IiefKY9t0dl+l4wOXDs39Wz7lIxuP9U9Edu4yJJOo6W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcXoiYZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcXoiYZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD98C4CEE5;
	Tue,  8 Apr 2025 12:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113737;
	bh=8j9rOk/5GJd/84Ab+wN55GP3c/1xS2su2ObUZSiOqdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcXoiYZ23QNQUubvBXLubcNvQaHUmKpAoDwlwdYQuQ6UmloCVSiuE5PsUYsoK+1Xi
	 LAFt4SCYkk3cc4hbK6gWcZ7xll924eJft0XyoYsNqbAX4GsE1NMiPmRWF6Nlh8PkR/
	 d/FM3yuVmtqPmbKPEZcg14lMYu5QeA49N75z64Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 238/268] platform/x86: ISST: Correct command storage data length
Date: Tue,  8 Apr 2025 12:50:49 +0200
Message-ID: <20250408104835.007841270@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 9462e74c5c983cce34019bfb27f734552bebe59f upstream.

After resume/online turbo limit ratio (TRL) is restored partially if
the admin explicitly changed TRL from user space.

A hash table is used to store SST mail box and MSR settings when modified
to restore those settings after resume or online. This uses a struct
isst_cmd field "data" to store these settings. This is a 64 bit field.
But isst_store_new_cmd() is only assigning as u32. This results in
truncation of 32 bits.

Change the argument to u64 from u32.

Fixes: f607874f35cb ("platform/x86: ISST: Restore state on resume")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250328224749.2691272-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -84,7 +84,7 @@ static DECLARE_HASHTABLE(isst_hash, 8);
 static DEFINE_MUTEX(isst_hash_lock);
 
 static int isst_store_new_cmd(int cmd, u32 cpu, int mbox_cmd_type, u32 param,
-			      u32 data)
+			      u64 data)
 {
 	struct isst_cmd *sst_cmd;
 


