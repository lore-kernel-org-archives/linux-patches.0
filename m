Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540477461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6416BC433C7;
	Sun, 17 Sep 2023 20:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981284;
	bh=zktxYCmdN+c06LV39b+cOOoA2b3BLPsP1eEK8VEjIfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnm5rRNpSns8nl0mi8vykJ5iZurxqSVMOwmRuTS3blNYANRkmZYTwWRqlvlwLIJjD
	 VlqScEoe1iRlXhVwdlKyJlDFVlyZ1kzfNKK+pLIA9vpwCKXm7FMRphQ0VSRPlSntpw
	 YQwv1LCfg4/sSKlEiP684g4cqfr2isPQSZuaaOBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ani Sinha <anisinha@redhat.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/511] vmbus_testing: fix wrong python syntax for integer value comparison
Date: Sun, 17 Sep 2023 21:07:40 +0200
Message-ID: <20230917191114.645689303@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ani Sinha <anisinha@redhat.com>

[ Upstream commit ed0cf84e9cc42e6310961c87709621f1825c2bb8 ]

It is incorrect in python to compare integer values using the "is" keyword.
The "is" keyword in python is used to compare references to two objects,
not their values. Newer version of python3 (version 3.8) throws a warning
when such incorrect comparison is made. For value comparison, "==" should
be used.

Fix this in the code and suppress the following warning:

/usr/sbin/vmbus_testing:167: SyntaxWarning: "is" with a literal. Did you mean "=="?

Signed-off-by: Ani Sinha <anisinha@redhat.com>
Link: https://lore.kernel.org/r/20230705134408.6302-1-anisinha@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/vmbus_testing | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/vmbus_testing b/tools/hv/vmbus_testing
index e7212903dd1d9..4467979d8f699 100755
--- a/tools/hv/vmbus_testing
+++ b/tools/hv/vmbus_testing
@@ -164,7 +164,7 @@ def recursive_file_lookup(path, file_map):
 def get_all_devices_test_status(file_map):
 
         for device in file_map:
-                if (get_test_state(locate_state(device, file_map)) is 1):
+                if (get_test_state(locate_state(device, file_map)) == 1):
                         print("Testing = ON for: {}"
                               .format(device.split("/")[5]))
                 else:
@@ -203,7 +203,7 @@ def write_test_files(path, value):
 def set_test_state(state_path, state_value, quiet):
 
         write_test_files(state_path, state_value)
-        if (get_test_state(state_path) is 1):
+        if (get_test_state(state_path) == 1):
                 if (not quiet):
                         print("Testing = ON for device: {}"
                               .format(state_path.split("/")[5]))
-- 
2.40.1



