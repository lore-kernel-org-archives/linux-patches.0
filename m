Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F97134A5
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A96DC433C8;
	Thu, 29 Jun 2023 18:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064435;
	bh=GprHvna917IUD3VThEejt+TTe8XAmtOwoj44XOQAXmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiKjhgqFdCBfeYZG8CLLGV/Zx+pMD45MKmeIWjQt/MmiEdDxPMU74IkRe9h0ZhIK4
	 WSjNVg0LBk5k/ujcvT9+mEz/02QG8f6lqoWKut41gHnLS6d8HTXWElBT5TzSPnW21U
	 0QDzcdyzq5AlGn0VIALgxeUb3ZhCxBmc9knSeGyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Wyes Karny <wyes.karny@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Perry Yuan <Perry.Yuan@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.3 09/29] cpufreq: amd-pstate: Make amd-pstate EPP driver name hyphenated
Date: Thu, 29 Jun 2023 20:43:39 +0200
Message-ID: <20230629184152.124264343@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wyes Karny <wyes.karny@amd.com>

commit f4aad639302a07454dcb23b408dcadf8a9efb031 upstream.

amd-pstate passive mode driver is hyphenated. So make amd-pstate active
mode driver consistent with that rename "amd_pstate_epp" to
"amd-pstate-epp".

Fixes: ffa5096a7c33 ("cpufreq: amd-pstate: implement Pstate EPP support for the AMD processors")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1272,7 +1272,7 @@ static struct cpufreq_driver amd_pstate_
 	.online		= amd_pstate_epp_cpu_online,
 	.suspend	= amd_pstate_epp_suspend,
 	.resume		= amd_pstate_epp_resume,
-	.name		= "amd_pstate_epp",
+	.name		= "amd-pstate-epp",
 	.attr		= amd_pstate_epp_attr,
 };
 


