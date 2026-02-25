Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E8F30F555;
	Wed, 25 Feb 2026 06:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002715; cv=none; b=ucVg8mlK7IBnE8ZM27uIAJL6rSt/5QYkCPP/4JqaoVH8Pggb+ovjVNuLjzCt6cKyarTBAlISwIj+/CZCVroAOc0uey6gx9ZiQhrF/A48qjurtUKL4kI1sssSEuaug/PRb93ZhUrmWMYnKhpEBW2qU3RTmAAROyX6KAjwUFIMbEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002715; c=relaxed/simple;
	bh=V3N/rVgqOl4pX6Aip+FNyW/bzPqd4nCOwY8N4EKwclk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHW133pb+QhFW6z4iQXuB9BDnrirjk1S5eCXxe0JEpqg1qv2wcNcSboL19Och157FtPYX4mYPHGovWTrqKyAGyNruLtXCzoFH8acGyLqiedtJ6UjcfrjY/H/OITCDMAGQoXveonZ8aRfH2LtBlFp0r0owMXddbdI6MX8C4pY3Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0iGgikN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0iGgikN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C803C116D0;
	Wed, 25 Feb 2026 06:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002715;
	bh=V3N/rVgqOl4pX6Aip+FNyW/bzPqd4nCOwY8N4EKwclk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0iGgikNDZi0SIFTeBZJpM49PfcoJNV8T5J82UVf6Y2uWEIftgZ1CXHEshq+MWeMV
	 L1s0jKns9sBFGTI7X2F3q49aRGMO+DowYrK5QJFPSa+rC7TV9XxkMt0h+FIZ1BFFiW
	 op9jG4AJeHnw6iPIc11hzxadhaCQfATzz34FsylM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 523/641] selftests: netconsole: Increase port listening timeout
Date: Tue, 24 Feb 2026 17:24:09 -0800
Message-ID: <20260225012401.201575230@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@google.com>

[ Upstream commit a68a9bd086c2822d0c629443bd16ad1317afe501 ]

wait_for_port() can wait up to 2 seconds with the sleep and the polling
in wait_local_port_listen() combined. So, in netcons_basic.sh, the socat
process could die before the test writes to the netconsole.

Increase the timeout to 3 seconds to make netcons_basic.sh pass
consistently.

Fixes: 3dc6c76391cb ("selftests: net: Add IPv6 support to netconsole basic tests")
Signed-off-by: Pin-yen Lin <treapking@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260210005939.3230550-1-treapking@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh b/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
index ae8abff4be409..64d3941576d5d 100644
--- a/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
+++ b/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
@@ -247,8 +247,8 @@ function listen_port_and_save_to() {
 		SOCAT_MODE="UDP6-LISTEN"
 	fi
 
-	# Just wait for 2 seconds
-	timeout 2 ip netns exec "${NAMESPACE}" \
+	# Just wait for 3 seconds
+	timeout 3 ip netns exec "${NAMESPACE}" \
 		socat "${SOCAT_MODE}":"${PORT}",fork "${OUTPUT}" 2> /dev/null
 }
 
-- 
2.51.0



