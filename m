Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A301B3F0E;
	Thu,  6 Jun 2024 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683429; cv=none; b=LUYQVNIzEE64VGAw8sFrSAMOqAmMpBLF7PQ1kzOUMIIrRG902NFHCBi8Z/z1Nm9b3P0ycrkyp49N8qglMCMLe+ZNuJ8F0/M90f5DPrwAQeK5NzoEp8EtOwU7vHhRvUXdAFEKg8/5Hm3c84GXdc32gTpWoxmJTeGmMINtUAS9z34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683429; c=relaxed/simple;
	bh=K8OBQC1OUCr/GwGN4rtmP50qRV+7BeVWKkk6kNmGtS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL/hJHxi4bz6BzGgpKBJNWc50hlxjjsRgDvMqmKTOXrl/vioEFHKT0VrxLI7U8xulqFxq8r1agsOEe4Eq0C6rCUzgo3tfDFuurF8zNRYld69v9jqX7bo36HBECrfxhGR3blqvgBRVjJ2B3pVmswf66eF/yfYPQRjxHWrdV5q2mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfOB1vce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfOB1vce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FDFC2BD10;
	Thu,  6 Jun 2024 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683429;
	bh=K8OBQC1OUCr/GwGN4rtmP50qRV+7BeVWKkk6kNmGtS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfOB1vceUU0S6LnRb3RFJ5J2kOmbZ56WtinJcvYzbDvLHiD21hCQHlTrFLePlf91c
	 vvVQYZ0yqjnXhfo73cvOiw3wsiODMyYq9Hcoh1qaJ72y2YBJ6+QoInltfgHkiVx2XU
	 4SBlmrhdl2qkZN2bjxYNCosmJiFMwgjuGFMcohos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 374/744] selftests/kcmp: remove unused open mode
Date: Thu,  6 Jun 2024 16:00:46 +0200
Message-ID: <20240606131744.474829089@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Liaw <edliaw@google.com>

[ Upstream commit eb59a58113717df04b8a8229befd8ab1e5dbf86e ]

Android bionic warns that open modes are ignored if O_CREAT or O_TMPFILE
aren't specified.  The permissions for the file are set above:

	fd1 = open(kpath, O_RDWR | O_CREAT | O_TRUNC, 0644);

Link: https://lkml.kernel.org/r/20240429234610.191144-1-edliaw@google.com
Fixes: d97b46a64674 ("syscalls, x86: add __NR_kcmp syscall")
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kcmp/kcmp_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcmp/kcmp_test.c b/tools/testing/selftests/kcmp/kcmp_test.c
index 25110c7c0b3ed..d7a8e321bb16b 100644
--- a/tools/testing/selftests/kcmp/kcmp_test.c
+++ b/tools/testing/selftests/kcmp/kcmp_test.c
@@ -91,7 +91,7 @@ int main(int argc, char **argv)
 		ksft_print_header();
 		ksft_set_plan(3);
 
-		fd2 = open(kpath, O_RDWR, 0644);
+		fd2 = open(kpath, O_RDWR);
 		if (fd2 < 0) {
 			perror("Can't open file");
 			ksft_exit_fail();
-- 
2.43.0



