Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC3127C875;
	Tue,  8 Apr 2025 12:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117077; cv=none; b=LCt++PBNYiJWvMT8E+CR98nRZUtJGOTUeiGdc45pBfhJdwfWBGqEUbStPhrMk4gnuUna3RP3T/Q2yrnH9Sg5teoc54YdLrIJFXK2vW1ewPM1xIrkdhx09AIcRoYKcGLxAU7DkpIuOAAzWOfdOF5jpHYOYc2XZdx2YbXRzi0Z6tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117077; c=relaxed/simple;
	bh=TvD/3vQ4Xez903AUj/5tUWGpKlH85dxceb4Ptlg0hd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=diofYJIT0JtdqGVwr0DNnhYBpPArKJuC/40BboWFVoCFNFoxfQcXBRx9xiiEircaIz7QgOiXIYZwIyMIqHBwsEgdKbuDm1Z/+dsiN/v6zmBf4DKropU1nbm/ZO3FS+WxP1/iQDSPTvGUUAlv8+ivKViTs6QNbYkO0kinyXR/Ez8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmnDJqpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmnDJqpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B15C4CEE5;
	Tue,  8 Apr 2025 12:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117077;
	bh=TvD/3vQ4Xez903AUj/5tUWGpKlH85dxceb4Ptlg0hd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmnDJqptHBnhcan2XQ/p/32gBoAWnZq2r0tkExesoCItlfi2M6bIM0bN/8D2GPmuq
	 poZKPpg+tgWHAUrtFTNp2bzDmTZpkiqe9T7r8tm1ZdjyMFi00Cg+Bb+URxGvWT6K3F
	 SUsVdjzzAREvLGVt08ZnakoYUeu+ej2rfjok1UPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 375/423] platform/x86: ISST: Correct command storage data length
Date: Tue,  8 Apr 2025 12:51:41 +0200
Message-ID: <20250408104854.605258073@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


