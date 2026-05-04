Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C5D3DE42B;
	Mon,  4 May 2026 13:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903177; cv=none; b=dz87LAaabn5S/JNLKBzlKrEaq86FiJEYfz678daqALVPyYj5qe+zmV2CYU+nqKVEMkEeZBk63ayT72P5Cdqfzgo6uNy4BIJB6Y7NdeJFAwcT2/B0Vkrf4tPkr26hLNA9hbB12VbPxC/MHnspfgkOWUL8WRf+rNXcBpdXVQkFugc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903177; c=relaxed/simple;
	bh=C9N59BalbPPHgkFUGbNOFcpqQnCS3zET0sOzeyFm7c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KikmeQ1P4A2h8nOWhOEsTXkNBQ5Z2JoBhwNPlW61UBSiauHnIL5/LXIfVxhglYFGiXM/ohx0vNz/WS4EEnrPJQbF0DzdeJx9Qo58T/Bu4dnm9itTouGrKXVtBi2ZsD9TRzXjQa6rqr5Zp8nu2GIbQz+zU1n0K0YC150kje8rX9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAcEphT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAcEphT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CB1C2BCB8;
	Mon,  4 May 2026 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903177;
	bh=C9N59BalbPPHgkFUGbNOFcpqQnCS3zET0sOzeyFm7c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAcEphT+UhBEfqjNOJ7sOahWqWiqyM4w+hfZ8WSLGgdvR84wNnzeg7bFETOWVqavC
	 SvmyGuZYLq2qqkwYuiHSzYcPFVyJjpAC4Gd+Ugbl6GtGQ5wiOR5/lQ+475Jgb/vfXu
	 LPkT4yLi8Qfss6I2JyH+tN0f9hSvBxRAAijb8Hw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.0 101/307] selftests/landlock: Fix format warning for __u64 in net_test
Date: Mon,  4 May 2026 15:49:46 +0200
Message-ID: <20260504135146.612948575@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit a060ac0b8c3345639f5f4a01e2c435d34adf7e3d upstream.

On architectures where __u64 is unsigned long (e.g. powerpc64), using
%llx to format a __u64 triggers a -Wformat warning because %llx expects
unsigned long long.  Cast the argument to unsigned long long.

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Fixes: a549d055a22e ("selftests/landlock: Add network tests")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202604020206.62zgOTeP-lkp@intel.com/
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260402192608.1458252-6-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/net_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -1356,7 +1356,7 @@ TEST_F(mini, network_access_rights)
 					    &net_port, 0))
 		{
 			TH_LOG("Failed to add rule with access 0x%llx: %s",
-			       access, strerror(errno));
+			       (unsigned long long)access, strerror(errno));
 		}
 	}
 	EXPECT_EQ(0, close(ruleset_fd));


