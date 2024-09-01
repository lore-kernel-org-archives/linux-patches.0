Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248155381A;
	Sun,  1 Sep 2024 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208422; cv=none; b=O2SHtmudILnEmsaZPeP80HAOyBU475+3mWpL2MMwPEKlX69sWloN5T5zsUygu0Yl1NffgpENBHrDsYWpQFukhR7a8bxlqCnmt0w0/sHDZhuJuO9z256nbFEwmhHfc4fFZ90WNkWV9Nw6Pj3ByOles03+AfFbYfAYoGbFT87WZq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208422; c=relaxed/simple;
	bh=v4g/Vz56LyYs8rzw2ISzuXYAoAjpzQ9D6Tx1kdZ0DaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaXGsDswLALM/Ahd/aa6347aTv+9YYc3LkLwqa/794PK065ZV8v0t7RpMqG+E4/s9DTXl7y7K3MocZYTPJtrh4bBjp4ir2XJgjTEbjH21BGCsLsHNc+JAokK7Rs/9IQ3sDB5vaCv36YlLQ0nmbo41Aq7jwcptG3Ihk06QcCpKQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJ9iY7u/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJ9iY7u/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBF5C4CEC3;
	Sun,  1 Sep 2024 16:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208422;
	bh=v4g/Vz56LyYs8rzw2ISzuXYAoAjpzQ9D6Tx1kdZ0DaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ9iY7u/7V4elHoI2Mck2dnYlkNBA3+i4yoUaQunanW7BXv2cw6GxzEU42sdEZ1a9
	 lWomxNysGd+MR/qPqdrbRDVTK2mp/QvlORP645eHn+dJkQIDqgezO+JgplEsBc59c4
	 w4KpVALBFWoRdneZO5bv40GG3tZiIfwYj/r/I6c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.10 077/149] cpufreq/amd-pstate: Use topology_logical_package_id() instead of logical_die_id()
Date: Sun,  1 Sep 2024 18:16:28 +0200
Message-ID: <20240901160820.363068340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

commit 0d8584d288a9b4132e945d76bcc04395d158b2e7 upstream.

After the commit 63edbaa48a57 ("x86/cpu/topology: Add support for the
AMD 0x80000026 leaf"), the topolgy_logical_die_id() function returns
the logical Core Chiplet Die (CCD) ID instead of the logical socket
ID.

Since this is currently used to set MSR_AMD_CPPC_ENABLE, which needs
to be set on any one of the threads of the socket, it is prudent to
use topology_logical_package_id() in place of
topology_logical_die_id().

Fixes: 63edbaa48a57 ("x86/cpu/topology: Add support for the AMD 0x80000026 leaf")
cc: stable@vger.kernel.org # 6.10
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Link: https://lore.kernel.org/lkml/20240801124509.3650-1-Dhananjay.Ugwekar@amd.com/
Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -329,7 +329,7 @@ static inline int pstate_enable(bool ena
 		return 0;
 
 	for_each_present_cpu(cpu) {
-		unsigned long logical_id = topology_logical_die_id(cpu);
+		unsigned long logical_id = topology_logical_package_id(cpu);
 
 		if (test_bit(logical_id, &logical_proc_id_mask))
 			continue;


