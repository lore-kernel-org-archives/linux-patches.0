Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407001DF266;
	Wed,  6 Nov 2024 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894939; cv=none; b=Ps35MrGkbo6/V5phlYU+WVAq93UXgHrVg8lFdbiVDn3LKjl2cBgMbPWfnoVr9dy5GuUWYbrgsYUpCRGbPg3fseCd18NnwfIWQ3pw5aE9qkEI2K+LiYcF8xlAhTILVgoWOqWhDANHbJSAC9S+hVcGzO8601U9wUItARYM8bFxPQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894939; c=relaxed/simple;
	bh=0HgiSCPJTjoyWoOl1fkk8CnRvNtnCPHoeQ7bYERstLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKOuPSllBtCwkYV8b7ObayCiW8jK4cnbYhWmqujk2rWX7xyKK80kSqccvjT5lBtybfffhs8BbvQy2oPnH+mplSAfuaS7M3dY72w9MQMHiPg2hBUce1rHgwARItnD4vob3h+vaTMum6la4riMvgGiWrGc5YvsdObum5O55/i41dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl4yB5vU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl4yB5vU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851C6C4CECD;
	Wed,  6 Nov 2024 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894938;
	bh=0HgiSCPJTjoyWoOl1fkk8CnRvNtnCPHoeQ7bYERstLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl4yB5vUJndduSyQVzzJut0qoFGYXXx6w0qEyeKIfK9ByxX8l9/3uC9EHhSudn//S
	 wIyg5Wmw8QlNSBh9x+wJOz43oCVeIwb109yvdj+y1AI4FOcfs50ptcW3UdJNx3CZaT
	 3kaZUJ+fa6jHEP12kVtsmKwxt4qKX048DYSoidiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 013/350] selftests/vm: remove call to ksft_set_plan()
Date: Wed,  6 Nov 2024 12:59:01 +0100
Message-ID: <20241106120321.198732716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

The function definition for ksft_set_plan() is not present in linux-4.19.y.
compaction_test selftest fails to compile because of this.

Fixes: 9a21701edc41 ("selftests/mm: conform test to TAP format output")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Reviewed-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/compaction_test.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/vm/compaction_test.c
+++ b/tools/testing/selftests/vm/compaction_test.c
@@ -183,8 +183,6 @@ int main(int argc, char **argv)
 	if (prereq() != 0)
 		return ksft_exit_pass();
 
-	ksft_set_plan(1);
-
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
 	if (setrlimit(RLIMIT_MEMLOCK, &lim))


