Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAFC28134C;
	Sat, 14 Feb 2026 21:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104318; cv=none; b=NI8PQepWkPDMqFJ8W3lYBVSAailguimEUCjK/CQb1ajvUWn1Hdsa3xgPJKZSu9IILFBRBNtdastkiV+sJwNxdkhLYb85lL2B6CiAZq3XlwV7q0ZBXPmbBIzsHk2WwPhhfRZIbhyAG8r42+N1fMOhIeZJSbBJ2ycdtw72LVossyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104318; c=relaxed/simple;
	bh=4xzav0BA4B7+VgAX4B0hEbO01AeRk2vnpR6CaYtY7bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dabAz7tmR4GxtNvaN8TrZVM5Mz+r64XYEz6rDA11euTGJZWImJZDHHeQnJ4ImcqBa3YeDxIueVXIRBaC9jt+hjRAit1fHajpSPKLqwLK+OCPkAD72ogwhn7lUraCrWJIHnA3du5ZAqC6+W/nOxyBbK05xgEqqa5HjBYrFuhasBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaOCd/yR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaOCd/yR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83406C19423;
	Sat, 14 Feb 2026 21:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104318;
	bh=4xzav0BA4B7+VgAX4B0hEbO01AeRk2vnpR6CaYtY7bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaOCd/yR3LEUG+67UC0y1QIkq2a89lxGbN8zsBjqAbYZP2BlmKSlctlvVs4PvMGS5
	 ko4hEXoXFQPXKsqePIvPCYnhLr32FVOo3OqkkhxFR3EZntsgVmzRIP0tJxeScufBtW
	 osbMCnxSAaV80Xaa+lLl0m2jaB1B142VxE/psQAdjYTk4+aqVoHYb97CO28EPqCktZ
	 m39/r8CkVhJS8tKaEfLURRNd/3ePi72I6vHcD1FTIGEtXvFHUoz3/3g8b0hz98jqQo
	 9JoglwIVUNKl2wYMnWANHS4hxiBT3F3fECMKYpCQrunTwL5g3nQLOihpnh7w+8DcqK
	 4LfBOI5ew1eSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	driver-core@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.18] driver core: faux: stop using static struct device
Date: Sat, 14 Feb 2026 16:22:38 -0500
Message-ID: <20260214212452.782265-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 61b76d07d2b46a86ea91267d36449fc78f8a1f6e ]

faux_bus_root should not have been a static struct device, but rather a
dynamically created structure so that lockdep and other testing tools do
not trip over it (as well as being the right thing overall to do.)  Fix
this up by making it properly dynamic.

Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://lore.kernel.org/lkml/CALbr=LYKJsj6cbrDLA07qioKhWJcRj+gW8=bq5=4ZvpEe2c4Yg@mail.gmail.com/
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026012145-lapping-countless-ef81@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Key Findings

1. **The faux bus (`drivers/base/faux.c`) was introduced in v6.14.** It
   would be present in stable trees 6.14.y, 6.15.y, 6.16.y, 6.17.y, and
   6.18.y (if those are maintained).

2. **The fix itself is legitimate**: Static `struct device` is a well-
   known anti-pattern that causes real lockdep issues. This was reported
   by a real user and fixed by the driver core maintainer (Greg KH
   himself).

3. **The fix is small and contained**: ~20 lines changed in a single
   file, converting a static struct to a dynamically allocated one. The
   logic is straightforward.

4. **Risk assessment**: LOW risk. The change is mechanical — converting
   static to dynamic allocation with proper init. Greg KH authored it
   and Danilo Krummrich reviewed it. The faux bus is infrastructure used
   by other drivers, so correctness matters.

5. **Bug impact**: Without this fix, lockdep and other testing/debugging
   tools produce false warnings or miss real bugs when the faux bus is
   used. This is a real correctness issue for kernel developers and CI
   systems testing on stable kernels.

### Stability Concerns

- The faux bus is relatively new infrastructure (v6.14+), so it only
  applies to very recent stable trees.
- The fix is self-contained — no dependencies on other commits.
- The commit is authored by Greg Kroah-Hartman, the stable tree
  maintainer himself, which adds confidence.

### Conclusion

This commit fixes a real bug (lockdep/testing tool issues caused by
using a static struct device, which is a known anti-pattern). It's a
small, contained fix authored by the driver core maintainer, reviewed by
another maintainer, and reported by a real user. It applies to stable
trees v6.14+ where the faux bus exists. The risk is low and the benefit
is clear — it prevents false lockdep warnings and potential issues with
testing tools.

**YES**

 drivers/base/faux.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/base/faux.c b/drivers/base/faux.c
index 21dd02124231a..23d7258172325 100644
--- a/drivers/base/faux.c
+++ b/drivers/base/faux.c
@@ -29,9 +29,7 @@ struct faux_object {
 };
 #define to_faux_object(dev) container_of_const(dev, struct faux_object, faux_dev.dev)
 
-static struct device faux_bus_root = {
-	.init_name	= "faux",
-};
+static struct device *faux_bus_root;
 
 static int faux_match(struct device *dev, const struct device_driver *drv)
 {
@@ -152,7 +150,7 @@ struct faux_device *faux_device_create_with_groups(const char *name,
 	if (parent)
 		dev->parent = parent;
 	else
-		dev->parent = &faux_bus_root;
+		dev->parent = faux_bus_root;
 	dev->bus = &faux_bus_type;
 	dev_set_name(dev, "%s", name);
 	device_set_pm_not_required(dev);
@@ -236,9 +234,15 @@ int __init faux_bus_init(void)
 {
 	int ret;
 
-	ret = device_register(&faux_bus_root);
+	faux_bus_root = kzalloc(sizeof(*faux_bus_root), GFP_KERNEL);
+	if (!faux_bus_root)
+		return -ENOMEM;
+
+	dev_set_name(faux_bus_root, "faux");
+
+	ret = device_register(faux_bus_root);
 	if (ret) {
-		put_device(&faux_bus_root);
+		put_device(faux_bus_root);
 		return ret;
 	}
 
@@ -256,6 +260,6 @@ int __init faux_bus_init(void)
 	bus_unregister(&faux_bus_type);
 
 error_bus:
-	device_unregister(&faux_bus_root);
+	device_unregister(faux_bus_root);
 	return ret;
 }
-- 
2.51.0

